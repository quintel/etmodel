# Simple tracker, used for watt-nu
#
# Usage; Tracker.instance.track("whatever")
#
class Tracker
  include Singleton
  LOG_FILE = Rails.root.join('log/tracking.log')

  def track(data, user = nil)
    user_string = user ? user.name : nil
    line = [
      Time.new,
      user_string,
      data[:tab],
      data[:sidebar],
      data[:slide],
      data[:slider],
      data[:new_value],
      data[:score]
    ].join(',')

    logger.info line
  end

  def clear_log
    File.open(LOG_FILE, 'w') {|f| f.puts Time.new}
  end

  private

  def logger
    @logger ||= Logger.new(LOG_FILE)
  end
end
