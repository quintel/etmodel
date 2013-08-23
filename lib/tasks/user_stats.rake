require 'terminal-table'

def plot_list(show_list,list_data,rows)
  if show_list
    unless list_data.nil?
      rows << :separator
      yield
    end
  end
  return rows
end

def plot_table(title,headings,rows)
  table = Terminal::Table.new :title => title, :headings => headings, :rows => rows, :style => {:width => 120}
  a = *(1..headings.size - 1).each { |i| table.align_column(i,:right) }
  puts table
end

desc 'Displays number of new user accounts over the last x days (period=x, default = 7 days).'
task :user_stats => [:environment] do
  number_of_periods   = ENV['periods'] || 1
  lists_shown         = ENV['list'] && ENV['list'].upcase=='TRUE' || false
  summary             = ENV['summary'] && (ENV['summary'].upcase=='TRUE' || ENV['summary'].upcase=='ONLY') || false
  summary_only        = ENV['summary'] && ENV['summary'].upcase=='ONLY' || false

  periods = *(1..number_of_periods.to_i)

  accounts_summary_rows = []
  scenario_summary_rows = []
  
  periods.each do |period|
    start_date  = Date.today.beginning_of_month.months_ago(periods.size - period)
    end_date    = Date.today.end_of_month.months_ago(periods.size - period)

    regular_users = User.where("company_school NOT IN ('AT&T','apple','microsoft','Quintel','Quintel Intelligence','QI') AND email NOT LIKE '%quintel%'")
    accounts      = User.where("created_at >= ? AND created_at <= ?", start_date, end_date)
    accounts_2    = regular_users.where("created_at >= ? AND created_at <= ?", start_date, end_date)
    scenarios     = SavedScenario.where("created_at >= ? AND created_at <= ?", start_date, end_date)

    scenarios.keep_if { |scenario| regular_users.map(&:id).include?(scenario.user_id) }

    title = "User Statistics"
    headings = []
    headings << {:value => "Metrics for period: #{start_date} - #{end_date}"}
    headings << {:value => "#\naccounts", :alignment => :center}
    headings << {:value => "Excl. QI\nand spam", :alignment => :center}
    rows = []
    rows << ["New accounts registered",accounts.size,accounts_2.size]
    accounts_summary_rows << ["#{start_date} - #{end_date}",accounts.size,accounts_2.size]
    plot_list(lists_shown,accounts_2,rows) do
      accounts_2.each do |account|
        marker = account.teacher_id.nil? ? "-" : "S"
        rows << ["#{marker} #{account.name.truncate(25)} (#{account.email.truncate(25)})",{:value => "#{account.company_school.truncate(40)}", :colspan => 2}]
      end
      unless accounts_2.group_by(&:teacher_id).size == 1 && accounts_2.group_by(&:teacher_id).keys[0].blank?
        rows << :separator
        rows << ["Referenced teachers",{:value => "# of registered students", :colspan => 2}]
        rows << :separator
      end
      accounts_2.group_by(&:teacher_id).each do |key,coll|
        rows << ["- #{User.find(key).name.truncate(25)} - #{User.find(key).company_school.truncate(20)}",{:value => coll.size, :colspan => 2}] unless key.nil?
      end
    end
    plot_table(title,headings,rows) unless summary_only

    headings[1] = {:value => "#\nscenarios", :alignment => :center}
    headings[2] = {:value => "# of\nusers", :alignment => :center}
    rows = []
    rows << ["New saved scenarios",scenarios.size,scenarios.map(&:user_id).uniq.size]
    scenario_summary_rows << ["#{start_date} - #{end_date}",scenarios.size,scenarios.map(&:user_id).uniq.size]
    plot_list(lists_shown,scenarios,rows) do
      scenarios.group_by(&:user_id).each do |key,scenarios|
        user = User.find(key)
        marker = accounts_2.map(&:id).include?(user.id) ? "-" : "R"
        rows << ["#{marker} #{user.name.truncate(25)} (#{scenarios.size} #{'scenario'.pluralize(scenarios.size)})",{:value => "#{user.company_school.truncate(40)}", :colspan => 2}]
      end
    end
    plot_table(title,headings,rows) unless summary_only
  end

  if summary
    title = "User Statistics - New accounts registered"
    headings = []
    headings << "Period"
    headings << {:value => "#\naccounts", :alignment => :center}
    headings << {:value => "Excl. QI\nand spam", :alignment => :center}
    plot_table(title,headings,accounts_summary_rows)

    title = "User Statistics - New saved scenarios"
    headings[1] = {:value => "#\nscenarios", :alignment => :center}
    headings[2] = {:value => "# of\nusers", :alignment => :center}
    plot_table(title,headings,scenario_summary_rows)
  end
end
