module DateHelper
  # TODO: replace with standard localization API
  def format_date_nicely_with_time(date)	   
     @month_names = [nil] + %w(januari februari maart april mei juni juli augustus september oktober november december)
     @month = date.strftime("%m").to_i
     @month_name = @month_names[@month]
   
     return h(date.strftime("%d " + @month_name + " \'%y, %H:%M"))
  end

  def format_date_nicely_veryshort(date)
    return h(date.strftime("%d-%m-%Y"))
  end
end