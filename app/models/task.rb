class Task < ActiveRecord::Base
  has_many :hours, :dependent => :destroy
  belongs_to :user
  attr_accessible :desc, :name, :public
  
  def total_hours
    self.hours.sum("ammt").to_f.round(2)
  end

''' OLD '''
  def by_day
    day_count = Array.new
    
    for i in 0..6
      day_count.push(self.hours.where(:start_time => ((DateTime.now.in_time_zone(self.user.time_zone).midnight - i.day)..(DateTime.now.in_time_zone(self.user.time_zone).midnight - (i-1).day))).sum("ammt").to_f.round(2))
    end
    
    return day_count
  end
''' OLD '''
  
  def hours_in_range(range, period, offset = 0)
    range_end = DateTime.now.in_time_zone(self.user.time_zone).midnight + 1.day
    # the offset is the number of periods previous, ie days, weeks, months
    range_end = case period
      when :day
        range_end - offset.day
      when :week
        range_end.end_of_week - offset.week
      when :month
        range_end.end_of_month - offset.month
      when :year
        range_end.end_of_year - offset.year
    end
    
    range_start = case period
      when :day
        range_end - range.day
      when :week
        range_end - range.week
      when :month
        range_end - range.month
      when :year
        range_end - range.year
    end
        
    return self.hours.where(:start_time => range_start..range_end)
  end

  def ammt_hours_in_range(range, period, offset = 0)
    hours_in_range = self.hours_in_range(range, period, offset)
    
    return hours_in_range.sum("ammt").to_f.round(2)
  end
  
'''
  def by_period(period)
    ammt_hours = Array.new
    
  end
'''
end
