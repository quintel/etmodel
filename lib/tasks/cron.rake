# frozen_string_literal: true

namespace :cron do
  # Removes scenarios which were discarded some time ago.
  task delete_discarded_scenarios: :environment do
    SavedScenario.destroy_old_discarded!
  end
end
