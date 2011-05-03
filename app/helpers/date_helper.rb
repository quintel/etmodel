module DateHelper
  def format_date_nicely_with_time(date)	   
     @month_names = [nil] + %w(januari februari maart april mei juni juli augustus september oktober november december)
     @month = date.strftime("%m").to_i
     @month_name = @month_names[@month]
   
     return h(date.strftime("%d " + @month_name + " \'%y, %H:%M"))
  end
	
  def format_date_nicely_short(date)
  	day = date.strftime("%d")
  	day = day.last if day.first == '0'
  	return h(day + " " + Date::MONTHNAMES[date.strftime("%m").to_i].downcase)
  end
  # 
  def format_date_nicely_veryshort(date)
    return h(date.strftime("%d-%m-%Y"))
  end

   def format_date_with_time(date)
  	day = date.strftime("%d")
  	day = day.last if day.first == '0'
  	return h(day + " " + Date::MONTHNAMES[date.strftime("%m").to_i] + " " + date.strftime("%H:%M"))
  end
end