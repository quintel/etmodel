# frozen_string_literal: true

# rubocop:disable Rails/RakeEnvironment

desc 'Print the current release name'
# Intentionally omits the :environment dependency to avoid loading Rails, keeping this fast.
task :show_release do
  require 'yaml'
  puts YAML.load_file('config/settings.yml')['release']
end

# rubocop:enable Rails/RakeEnvironment
