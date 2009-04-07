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
      :limit => number
    }
  }

  named_scope :by_date, lambda {
    {
      :order => "created_at DESC"
    }
  }

  named_scope :tagged_with, lambda {|tag|
    {
      :conditions => ["message LIKE (?)", "%#" + tag.to_s + "%"]
    }
  }
  
  def has_hashtag?
    return (message && message.match(Hashtag)) ? true : false
  end

  def self.recent_updates_for(project=nil)
    if project
      return self.recent(100).by_date.for_project(project)
    else
      return self.recent(100).by_date
    end
  end
  
  def self.recently_tagged_with(tag, project=nil)
    if project
      return self.recent(100).by_date.for_project(project).tagged_with(tag)
    else
      return self.recent(100).by_date.tagged_with(tag)
    end
  end
end
