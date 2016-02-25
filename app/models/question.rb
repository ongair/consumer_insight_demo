class Question < ActiveRecord::Base
  belongs_to :step
  has_many :options


	# def next_step
	# 	Question.where('id > ? ', id).first
	# end

end
