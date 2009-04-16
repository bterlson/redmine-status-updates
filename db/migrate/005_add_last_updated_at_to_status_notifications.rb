class AddLastUpdatedAtToStatusNotifications < ActiveRecord::Migration
  def self.up
    add_column :status_notifications, :last_updated_at, :datetime
  end
 
  def self.down
    remove_column :status_notifications, :last_updated_at
  end
end
