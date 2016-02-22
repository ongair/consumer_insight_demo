class Progress < ActiveRecord::Base
  belongs_to :step
  belongs_to :reviewer
end
