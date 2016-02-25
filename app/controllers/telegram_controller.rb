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

    reviewer_data(chat_id, reviewer)
    responses(chat_id, message, reviewer, current_step)

    render json: params
  end

  def responses chat_id, message, reviewer, current_step
  	if current_step.nil?
      Telegram.send_message(chat_id, Step.first.questions.first.text, false, [['Yes'], ['No']])
      Progress.create! step: Step.first, reviewer: reviewer
    else
      response = Response.find_or_create_by! reviewer: reviewer, question: current_step.questions.first
      if !current_step.next_step.nil?
        puts ">>>> #{current_step.name}"
        Progress.create! step: current_step.next_step, reviewer: reviewer
        response.update(text: message)
        current_step = reviewer.current_step
        
        options = []
        hide_keyboard = true

        # step_type = Step.all.collect{|s|s.step_type}

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
        # a choice is made between male and female and value set to message variable
      else
        response.update(text: message)
        Telegram.send_message(reviewer.telegram_id, "Thanks for your time.", true, [])
      end
    end
  end

  def reviewer_data chat_id, reviewer
    name = params["message"]["from"]["first_name"]
    # check_reviewer = Reviewer.find_by! name: name, telegram_id: chat_id
    if reviewer.name.blank? == true
      puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>.-------------------------- #{name}"
      reviewer.update(name: name)
      Telegram.send_message(chat_id, "Welcome #{name} to our quick survey?", true, [])
    end
  end
  
end