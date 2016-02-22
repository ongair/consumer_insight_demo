class Step < ActiveRecord::Base
	has_many :progresses
	has_many :questions
	belongs_to :wizard

	def next_step
		Step.where('id > ? ', id).first
	end
end