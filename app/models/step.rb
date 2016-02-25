class Step < ActiveRecord::Base
	belongs_to :next_step, class_name: "Step" # Self referential
	has_many :progresses
	has_many :questions
	belongs_to :wizard

	def is_first_step?
		# find out if this step is the first step
		id == Step.first.id
	end
end