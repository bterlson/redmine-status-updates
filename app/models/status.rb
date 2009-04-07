class Status < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  Hashtag = /(#\S+)/

  named_scope :for_project, lambda {|project|
    {
      :conditions => {:project_id => project.id}
    }
  }
  
  named_scope :recent, lambda {|number|
    {
      :limit => 100
    }
  }

  named_scope :by_date, lambda {
    {
      :order => "created_at DESC"
    }
  }
  
  def has_hashtag?
    return (message && message.match(Hashtag)) ? true : false
  end
end
