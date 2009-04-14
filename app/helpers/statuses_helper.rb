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

  # Returns a link to the specific project for the status
  def format_project(status)
    return '' if @project # on project, no linking needed
    returning '' do |values|
      if status.project
        values << link_to(h(status.project.name), {:controller => 'projects', :action => 'show', :id => status.project}, :class => 'smaller_project')
      end
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


  def tag_cloud(tags, classes)
    max, min = 0, 0
    tags.each do |name, count|
      max = count.to_i if count.to_i > max
      min = count.to_i if count.to_i < min
    end

    divisor = ((max - min) / classes.size) + 1

    tags.each { |name, count|
      yield name, classes[(count.to_i - min) / divisor]
    }
  end


  def status_menu(&block)
    content = ''
    content << link_to("All statuses", {:action => 'index', :id => @project}, :class => 'icon icon-index')
    content << link_to("Tag Cloud", {:action => 'tag_cloud', :id => @project}, :class => 'icon icon-comment')

    block_content = yield if block_given?
    content << block_content if block_content
    
    content_tag(:div,
                content,
                :class => "contextual")

  end

  def projects_with_create_status_permission
    User.current.projects.find(:all, :conditions => Project.allowed_to_condition(User.current, :create_statuses))
  end
end
