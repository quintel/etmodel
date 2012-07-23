##
# Wrapper for (user-) variables of a request that are accessible to all models.
#
# I created a new Setting class, which holds all the settings specific for a user session. Such as :backcasting_enabled and so on.
#
# == Current.setting
#
# Holds all the settings specific for a user session. Such as :backcasting_enabled and so on.
# Attributes in Setting are meant for front-end and similar things. And cannot influence the GQL.
#
#   Current.setting.backcasting_enabled
#   Current.setting.backcasting_enabled = false
#
# At any point if you want to reset settings:
#
#   Current.setting.reset!
#   # which does more less the same as:
#   Current.setting = Setting.default
#
# The setting object will be persisted in the session.
#
#
# == Implementation details
#
# Current is a Singleton. Because it is used often throughout the model (and
# because of legacy-reasons), Current is also the shortcut for Current.instance.
# This is implemented by generating class methods calling the singleton methods.
#
# I chose not to use the singleton module "include Singleton" because I want to
# actually be able to reset the Current by setting the @@instance to nil. Singleton
# module won't let you do this.
#
class Current

  attr_accessor :graph_id

  def session
    @session ||= {}
  end

  def session=(session)
    @session = session
  end

  def setting=(setting)
    session[:setting] = setting
  end

  def setting
    session[:setting] ||= Setting.default
  end

  def current_slide=(current_slide)
    session[:current_slide] = current_slide
  end

  def current_slide
    session[:current_slide]
  end

  def backcasting_enabled
    dutch?
  end

  ##
  # Singleton instance
  #
  def self.instance
    @instance ||= Current.new
  end

  ##
  # Run after every request. Make sure, that other users don't use
  # the current settings.
  #
  def self.teardown_after_request!
    @instance = nil
  end

  ##
  # Forward methods to the (singleton)-instance methods.
  # So that we can type Current.foo instead of Current.instance.foo
  #
  class << self
    def method_missing(name, *args)
      self.instance.send(name, *args)
    end
  end
end
