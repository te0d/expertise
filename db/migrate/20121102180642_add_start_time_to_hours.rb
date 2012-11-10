class AddStartTimeToHours < ActiveRecord::Migration
  def change
    add_column :hours, :start_time, :datetime
  end
end
