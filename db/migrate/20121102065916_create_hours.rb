class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.decimal :ammt
      t.references :task

      t.timestamps
    end
    add_index :hours, :task_id
  end
end
