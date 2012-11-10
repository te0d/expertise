class AddNotesToHours < ActiveRecord::Migration
  def change
    add_column :hours, :notes, :text
  end
end
