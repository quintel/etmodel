##
# Class for all server configuration settings.
# 
# See Current class, for more documentation on how this is used.
#
# Configuration files can be found in:
# config/server_configs/#{config.to_s}.yml
#
#
class ServerConfig
  DEFAULT_ATTRIBUTES = {
    :whitelist_file => nil,       # [string]  file which contains whitelists
    :root_page => nil,            # [string]  redirects directly to this page
    :unselectable_text => false,  # [boolean] makes all text unselectable, introduced for the touchscreen
    :debug_qernel => false,       # [boolean] states if we have to debug qernel stuff
    :header_logo => nil,          # [string]  special head logo
    :save_button => false,        # [boolean] displays the save button in the main template (or not)
    :max_scenarios => nil,         # [string]  special head logo
    :hoptoad_api_key => nil,        # [string]  contains API KEY from hoptoad
    :api_url => nil
  }
  
  DEFAULT_ATTRIBUTES.each do |key, value|
    attr_accessor key
  end

  # A subdomain can override the standard configuration in which the server
  # is started. This hash is used to decide if a subdomain has a associated
  # server config. 
  SUBDOMAIN_CONFIGS = {
    "touchscreen" => "touchscreen"
  }
  
  attr_reader :name
  
  @@cached_server_configs = {}
  
  ##
  #
  # @param [Hash] attributes
  # @param [Hash] options {:name => :default}
  #
  # @tested 2010-12-28 jape
  #
  def initialize(attributes = {}, options = {}) 
    @name = options[:name] || nil
    attributes = self.class.default_attributes.merge(attributes)
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end
  end
  
  ##
  # @return [ServerConfig] The default server configuration
  #
  # @tested 2010-12-28 jape
  #
  def self.default
    new(default_attributes, :name => :default)
  end
  
  
  ##
  # Loads a predefined file that defines a config. 
  #
  # The config file is at this location:
  #   config/server_configs/#{config.to_s}.yml
  #
  # If config is nil, this loads the default config.
  #
  # @cached
  # 
  # @param [Symbol] config 
  # @return [Hash] The Configuration of server or defaults
  #
  # @tested 2010-12-28 jape
  #
  def self.from_config(config)
    config = config.nil? ? nil : config.to_sym
    
    @@cached_server_configs = {} if Rails.env.development? # Empty cache first saves us a lot of server reboots
    @@cached_server_configs[config] ||= begin
      if !config.nil?
        self.from_file(File.join(Rails.root, 'config', 'server_configs', "%s.yml" % config.to_s), :name => config)
      else
        self.default
      end
    end
  end

  
  ##
  # Loads a config file from file. Use ServerConfig.from_config, because that
  # one is cached.
  #
  # @params [String] file
  # @params [Hash] options
  # @return [Hash] The Configuration of server
  #
  # @tested 2010-12-28 jape
  #
  def self.from_file(file, options = {})
    new(YAML.load_file(file) || {}, options)
  end
  
  
  ##
  # @return [Hash] Default attributes
  #
  # @tested 2010-12-28 jape
  #
  def self.default_attributes
    DEFAULT_ATTRIBUTES
  end

  ##
  # This returns the config associated with a subdomain.
  #
  # @param [String] subdomain
  # @return [Hash] Configuration that overrides defaults of specific servers.
  #
  # @tested 2010-12-28 jape
  #
  def self.override_for_subdomain(subdomain)
    SUBDOMAIN_CONFIGS[subdomain]
  end
  
  
  #
  # A server config can have a whitelist_file. If it has one, this is
  # loaded here and put into a instance variable.
  #
  # @return [[Integer, Integer]] Array with input element ids.
  #
  # @tested 2010-12-28 jape
  #
  def whitelist
    return nil if self.whitelist_file.nil?
    @whitelist ||= YAML.load_file(File.join(Rails.root, self.whitelist_file)).split(" ").map(&:to_i)
  end
  
end