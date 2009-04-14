class CreateStatusNotifications < ActiveRecord::Migration
  def self.up
    create_table :status_notifications do |t|
      t.references :user
      t.column :option, :string
    end

    add_index :status_notifications, :user_id
    add_index :status_notifications, :option
  end
 
  def self.down
    remove_index :status_notifications, :user_id
    remove_index :status_notifications, :option
    drop_table :status_notifications
  end
end
