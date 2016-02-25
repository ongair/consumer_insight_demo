require 'telegrammer'

class Telegram
	
	def self.bot
		Telegrammer::Bot.new('185029272:AAF_TieTe5U4_MXnsi5GfmuqCxm9-nqRBOU')
	end

	def self.reply_markup options = ["Male", "Female"]
		Telegrammer::DataTypes::ReplyKeyboardMarkup.new(	
			keyboard: options,
			resize_keyboard: true
		)
	end

	def self.hide_keyboard
		reply_markup = Telegrammer::DataTypes::ReplyKeyboardHide.new(
			hide_keyboard: true
		)
	end

	def self.send_message chat_id, text, hide=false, options
		if hide
			rm = hide_keyboard
		else
			rm = reply_markup(options)
		end
		bot.send_message(chat_id: chat_id, text: text, reply_markup:rm)
	end

	def self.set_webhook url
		bot.set_webhook(url)
	end
end