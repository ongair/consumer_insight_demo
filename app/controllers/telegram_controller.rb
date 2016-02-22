require 'telegram'

class TelegramController < ApplicationController
  def incoming
  	chat_id = params["message"]["chat"]["id"]
	message = params["message"]["text"]

	puts ">>>>>>>>>>>>>>>>>> #{message}"

	reviewer = Reviewer.find_or_create_by! telegram_id: chat_id
	current_step = reviewer.current_step

	render json: params
  end

  def sign_up
  	
  end

end
