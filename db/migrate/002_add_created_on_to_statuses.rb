class AddCreatedOnToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :created_on, :date
  end
 
  def self.down
    remove_column :statuses, :created_on
  end
end
