class Hour < ActiveRecord::Base
  belongs_to :task
  attr_accessible :ammt, :start_time, :notes
end
