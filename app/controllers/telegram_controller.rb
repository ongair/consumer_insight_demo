require 'telegram'

class TelegramController < ApplicationController
  def incoming
    chat_id = params["message"]["chat"]["id"]
    message = params["message"]["text"]

    puts ">>>>>>>>>>>>>>>>>> #{message}"

    # question = Question
    reviewer = Reviewer.find_or_create_by! telegram_id: chat_id
    # response = Response.find_or_create_by! reviewer: reviewer, question: Step.first.questions.first
    current_step = reviewer.current_step

    # start_wizard(chat_id, reviewer, params)
    if message == "/reset" || message == "reset"
      clear_data(reviewer)
      Telegram.send_message(chat_id, "Send /start to restart the questionnaire!", true, [])
    else
      responses(chat_id, message, reviewer, current_step)
    end

    render json: params
  end

  def responses chat_id, message, reviewer, current_step
    if current_step.nil?
      Telegram.send_message(chat_id, Step.first.questions.first.text, false, [['Yes'], ['No']])
      Progress.create! step: Step.first, reviewer: reviewer
      # clear_data(chat_id, reviewer, message)
    else
      if current_step.is_first_step?
        if message == "No"
          clear_data(reviewer)
          Telegram.send_message(chat_id, "Kindly watch the video. then key in /start to begin!", true, [])
        end
      end
      question = current_step.questions.select{|q| !q.options.blank?}.first
      if question.options.collect{|o| o.text}.include?(message)
        response = Response.find_or_create_by! reviewer: reviewer, question: current_step.questions.first
        if !current_step.next_step.nil?
          puts ">>>> #{current_step.name}"
          Progress.create! step: current_step.next_step, reviewer: reviewer
          response.update(text: message)
          current_step = reviewer.current_step
          
          options = []
          hide_keyboard = true

          step_type = Step.all.collect{|s|s.step_type}

          if current_step.step_type == "menu"
            opts = current_step.questions.first.options
            
            if opts.count == 15
              group_size = 3
            elsif opts.count == 10
              group_size = 5
            else
              group_size = 2
            end
            options = opts.collect{|o| o.text}.in_groups_of(group_size)
            hide_keyboard = false
          end
          question_text = current_step.questions.first.text
          
          if current_step.questions.count > 1
            # question_text = current_step.questions.collect{|q| q.text}.join("\n\n")
            # options = current_step.questions.select{|q| !q.options.blank?}.first.options.collect{|o| o.text }.in_groups_of(group_size)
            current_step.questions.each do |question|
              if question.options.blank?
                Telegram.send_message(reviewer.telegram_id, question.text, true, [])
              else
                options = question.options.collect{|o| o.text}.in_groups_of(5)
                Telegram.send_message(reviewer.telegram_id, question.text, false, options)
              end
            end
          else
            Telegram.send_message(reviewer.telegram_id, question_text, hide_keyboard, options)
          end
        else
          response.update(text: message)
          Telegram.send_message(reviewer.telegram_id, "Thanks for your time.", true, [])
        end
      else
        Telegram.send_message(reviewer.telegram_id, "Please choose among the given options!.", false, [])
      end
    end
  end

  def start_wizard chat_id, reviewer, message
    name = params["message"]["from"]["first_name"]

    if reviewer.current_step.nil?
      puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> -------------------------- #{name}"
      reviewer.update(name: name)
      Telegram.send_message(chat_id, "Welcome #{name} to our quick survey?", true, [])
    end
  end

  def clear_data reviewer
      # give user the power do delete their input
      # delete the user responses
      reviewer.responses.delete_all
      # gets rid of the user progress
      reviewer.progresses.delete_all

  end
  
end