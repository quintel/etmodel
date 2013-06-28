desc 'Sends mail to all users that allow for updates on ETM. Provide subject, template (w/o extension(s)) and set force to TRUE to actually send mails'
task :send_mail => [:environment] do
  subject  = ENV['subject']
  template = ENV['template']
  force    = ENV['force'] && ENV['force'].upcase == 'TRUE'

  users = User.where(allow_news: true)
  users = users.uniq { |user| user.email }
  users = users.delete_if { |user| /@quintel/.match(user.email) }
  users = users.delete_if { |user| user.saved_scenarios.size == 0 }

  puts "Total # of users            : #{ User.all.count }"
  puts "# of users allowing updates : #{ users.count }"

  unless subject && !subject.blank?
    puts 'Please provide subject'
    exit
  end

  template_path = File.join(Rails.root,'app','views','user_mailer')

  unless template && File.fnmatch(File.join(template_path, template + '.*'), File.join(template_path, template + '.'))
    puts 'Invalid template or not found in app/views/user_mailer'
    exit
  end

  users.each do |user|
    UserMailer.support_mail(user, subject, template).deliver if force
    puts "Mail sent to user #{ user.id }: #{ user.email }"
  end

  puts "This was a dry run. Please add force=TRUE to the command to actually send e-mails" unless force

end
