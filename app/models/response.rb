class Response < ActiveRecord::Base
  belongs_to :reviewer
  belongs_to :question
end
