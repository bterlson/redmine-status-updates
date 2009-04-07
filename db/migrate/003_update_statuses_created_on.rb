class UpdateStatusesCreatedOn < ActiveRecord::Migration
  def self.up
    Status.find(:all).each do |status|
      status.update_attribute(:created_on, status.created_at)
    end
  end
 
  def self.down
    # no-op
  end
end
