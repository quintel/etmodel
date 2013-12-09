namespace :db do
  desc <<-DESC
    Create an admin user
  DESC

  task :create_admin => [:environment] do
    puts "Please enter email address:"
    email = $stdin.gets.chomp
    puts "Please enter password:"
    password = $stdin.gets.chomp

    User.create!(name: "Rake generated Admin User",
                 email: email,
                 password: password,
                 password_confirmation: password,
                 allow_news: false,
                 role_id: 1)
  end

end
