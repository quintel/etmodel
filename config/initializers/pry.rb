Etm::Application.configure do
  unless Rails.env.production?
    # Use Pry instead of IRB
    silence_warnings do
      begin
        require 'pry'
        IRB = Pry
      rescue LoadError
      end
    end
  end
end
