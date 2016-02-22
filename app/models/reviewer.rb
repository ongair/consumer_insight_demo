class Reviewer < ActiveRecord::Base
	has_many :progresses

	def current_step
		step = nil
		step = progresses.last.step if !progresses.last.nil?
		step
	end
end
