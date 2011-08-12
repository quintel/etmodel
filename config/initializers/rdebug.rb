if APP_CONFIG[:enable_rdebug]
  if (Rails.env.development? || Rails.env.test?) && !$rails_rake_task
    require 'ruby-debug'
    
    Debugger.settings[:autoeval] = true
    Debugger.settings[:autolist] = 1
    Debugger.settings[:reload_source_on_change] = true
    Debugger.start_remote
  end
end