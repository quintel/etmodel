##
# Wrapper for (user-) variables of a request that are accessible to all models.
#
# I created a new Setting class, which holds all the settings specific for a user session. Such as :show_municipality_introduction and so on. 
# 
# == Current.setting
# 
# Holds all the settings specific for a user session. Such as :show_municipality_introduction and so on. 
# Attributes in Setting are meant for front-end and similar things. And cannot influence the GQL.
# 
#   Current.setting.show_municipality_introduction
#   Current.setting.show_municipality_introduction = false
# 
# At any point if you want to reset settings:
#
#   Current.reset_setting!
#   # which is a shortcut to
#   Current.setting.reset!
#   # which does more less the same as:
#   Current.setting = Setting.default
# 
# The setting object will be persisted in the session.
#
# == Current.scenario
#
# At any point if you want to reset the scenario:
#
#   Current.reset_to_default_scenario!
#   # which is the same as:
#   Current.scenario = Scenario.default
#
# == Scenario vs Setting
# 
# A big difference between Setting and Scenario is, that Scenario influences the GQL.
# E.g. in scenario we set end_year, can overwrite number_of_households, etc.
#
# == Current.server_config
#
# Holds all server specific variables. On some servers special things need to happen.
# Add a configuration file like: config/server_configs/name.yml to add specific server configurations.
#
# Change the SERVER_CONFIG variable in server_variables.rb on the deployed server to make sure it loads
# the correct server config.
#
# The server config is defined in this order:
#    1. It checks first the subdomain. If it is in the ServerConfig::SUBDOMAIN_CONFIGS 
#       it gets this config.
#       
#    2. The environment variable ENV["SERVER_CONFIG"]. Rails can be started with: 
#       > SERVER_CONFIG=testing rails s
# 
#    3. ENV["SERVER_CONFIG"] defined in server_variables.rb.
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
#
#
class Current
  
  attr_accessor :graph_id, :view


  def session
    @session ||= {}
  end

  def session=(session)
    @session = session
  end

  def scenario=(scenario)
    session[:scenario] = scenario
    scenario.load!
  end

  def scenario
    session[:scenario] ||= Scenario.default
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
 
  def subdomain
    session[:subdomain]
  end
  
  # This is loaded in application_controller.
  def subdomain=(subdomain)
    session[:subdomain] = subdomain
  end


  # Loads the server config. Caching is done in +ServerConfig.from_config+.
  # 
  #
  # @tested 2010-12-28 jape
  #
  def server_config
    if !subdomain.nil? && override = ServerConfig.override_for_subdomain(subdomain)
      return ServerConfig.from_config(override)
    end
      
    server_config = ENV['SERVER_CONFIG'] ? ENV['SERVER_CONFIG'] : nil

    if Rails.env.development?
      ServerConfig.from_config(server_config) 
    else
      session[:server_config] ||= ServerConfig.from_config(server_config) 
    end
  end

  # TODO refactor or make a bit more clear&transparent
  def graph
    unless @graph
      region_or_country = scenario.region_or_country

      @graph = self.user_graph

      raise "No graph for: #{region_or_country}" unless @graph
      raise "No Area data for: #{region_or_country}" unless Area.find_by_country(region_or_country)
    end
    @graph
  end

  ##
  # Manually set the Graph that is active for the GQl
  #
  # @param [Graph] graph 
  #
  def graph=(graph)
    @graph = graph
  end

  # TODO renmae user_graph to graph... but we have def graph already :(
  def user_graph
    if self.graph_id
      Graph.find(self.graph_id)
    else
      region_or_country = scenario.region_or_country
      Graph.latest_from_country(region_or_country)
    end
  end


  ##
  # is the GQL calculated? If true, prevent the programmers
  # to add further update statements ({Scenario#add_update_statements}). 
  # Because they won't affect the system anymore.
  #
  # @return [Boolean]
  #
  def gql_calculated?
    # We have to access the gql with @gql, because accessing it with self.gql
    # would initialize it. If gql is not initialized it is also not calculated.
    @gql.andand.calculated? == true
  end

  ##
  # Access the GQL through Current.gql
  # Lazy loads the latest graph if no gql has been manually assigned yet
  # (for example if you want to show an older version)
  def gql
    @gql ||= graph.andand.gql
  end

  def gql=(gql)
    @gql = gql
  end

  ##
  #
  #
  def constraints
    Constraint.all
  end


  ##
  # Use for pages that should only be shown once to a user.
  # Example Usage in controller:
  #
  #   if Current.already_shown?("demand/intro")
  #     redirect_to :action => 'index'
  #   else 
  #    render :action => 'show'
  #   end
  #
  #
  # @param key [String] key of page, normally the path
  # @param touch [Boolean] save key as shown; default true.
  # @return true if page has been shown once
  # @return false if page hasn't been shown yet
  #
  def already_shown?(key, touch = true)
    session['already_shown'] ||= []
    if session['already_shown'].include?(key.to_s)
      true
    else
      session['already_shown'] << key.to_s if touch
      false
    end
  end

  def load_graph_from_marshal(filename)
    raise "File '#{filename}' does not exist" unless File.exists?(filename)
    self.gql = Marshal.load(File.read(filename))
    scenario.area = self.gql.present.area

    self.gql.prepare_graphs
  end


  ##############################
  # Resetting
  ##############################

  ##
  # Resets to all default values. Will also reset country and year!
  #
  # Do not use this method to reset slider values!
  #
  # @untested 2010-12-27 seb
  #
  def reset_to_default!
    reset_to_default_scenario!
    reset_to_default_setting!
  end

  ##
  # Set to default scenario. Also overwrites year and country values!
  #
  # Do not use this method to reset slider values!
  #
  # @untested 2010-12-27 seb
  #
  def reset_to_default_scenario!
    scenario = Scenario.default
  end

  ##
  # Resets the scenarios from user values. But not what country, year we're in.
  #
  # @untested 2010-12-27 seb
  #
  def reset_scenario!
    scenario.reset_user_values!
  end

  ##
  # Resets user values. Currently equivalent to resetting to default values
  #
  # @untested 2010-12-27 seb
  #
  def reset_setting!
    setting.reset!

    # TODO: move into either scenario or setting
    session["house_label_new"] = nil
    session["house_label_existing"] = nil
    OutputElementSerie.block_charts.order('`group`').each do |block|
      session["block_#{block.id}"] = nil
    end
  end
  alias_method :reset_to_default_setting!, :reset_setting!

  def reset_user_session!
    self.reset_to_default!
  end

  def reset_gql
    self.scenario.reset_user_values!
    
    self.gql = nil
    self.graph_id = nil

    @graph = nil
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
