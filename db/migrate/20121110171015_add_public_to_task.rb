class AddPublicToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :public, :boolean, :default => false
  end
end
