module StatusesHelper
  def format_status_day(time)
    time.to_date == Date.today ? l(:label_today).titleize : format_date(time)
  end
end
