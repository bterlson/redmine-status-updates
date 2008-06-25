class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.references :user
      t.references :project
      
      t.column :message, :string
      
      t.timestamps
    end
  end
 
  def self.down
    drop_table :statuses
  end
end