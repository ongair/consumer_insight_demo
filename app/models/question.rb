class Question < ActiveRecord::Base
  belongs_to :step
  has_many :options
end
