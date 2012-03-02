# Simple tracker, used for watt-nu
#
# Usage; Tracker.instance.track("whatever")
#
class Tracker
  include Singleton

  def track(data, user = nil)
    user_string = user ? user.name : nil
    logger.info "#{Time.new}: #{user_string} #{data.to_json}"
  end

  private

  def logger
    @logger ||= Logger.new(Rails.root.join('log/tracking.log'))
  end
end
