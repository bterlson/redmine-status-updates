class Status < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  Hashtag = /(#\S+)/
  
  def has_hashtag?
    return (message && message.match(Hashtag)) ? true : false
  end
end
