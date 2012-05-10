# Run with the guard ruby gem in order to regenerate index.html whenever
# the readme is changed, and rebuild the minified version of the library
# whenever the main file is changed.
#
# Install Guard with:
#
#   $ gem install guard
#
# For better performance (and battery life) then:
#
#   $ gem install rb-fsevent growl (OS X)
#   $ gem install rb-fchange (Windows)
#   $ gem install rb-inotify (Linux)

def say(message)
  time = Time.now

  puts "[%02d:%02d:%02d] #{message}" % [
    time.hour, time.min, time.sec
  ]
end

guard 'guard' do
  watch('jquery.quinn.js') { `rake minified` ; say 'Minified library' }

  watch('README.md')       { `rake readme`   ; say 'Built index.html' }
end

# :set syntax=ruby
