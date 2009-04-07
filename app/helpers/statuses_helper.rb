module StatusesHelper
  def format_status_day(time)
    time.to_date == Date.today ? l(:label_today).titleize : format_date(time)
  end

  def format_status_message(status)
    if status.has_hashtag?
      link_hash_tags(status.message)
    else
      status.message
    end
  end

  def link_hash_tags(message)
    formatted_message = []
    message.split(/ /).each do |word|
      if word.match(/^#/)
        formatted_message << link_to(word, :controller => 'statuses', :action => 'tagged', :id => @project, :tag => word.sub('#',''))
      else
        formatted_message << word
      end
    end

    return formatted_message.join(' ')
  end
end
