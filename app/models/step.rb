class Step < ActiveRecord::Base
	belongs_to :next_step, class_name: "Step" # Self referential
	has_many :progresses
	has_many :questions
	belongs_to :wizard

	# def next_step
	# 	Step.where('id > ? ', id).first
	# end
end