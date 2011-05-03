module SessionAccessor
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def session_accessor(*args)
      session_reader(*args)
      session_writer(*args)
    end

    def session_reader(*args)
      opts = args.extract_options!
      args.each do |key|
        if opts.has_key?(:default)
          class_eval <<-EOS
            def self.#{key}
              if session[:#{key}] == nil
                session[:#{key}] = #{opts[:default].inspect}
              end
              session[:#{key}]
            end
          EOS
        else
          class_eval "def self.#{key}\n session[:#{key}]\n end\n\n"
        end
      end
    end

    def session_writer(*args)
      opts = args.extract_options!
      args.flatten.each do |key|
        class_eval "def self.#{key}=(val)\n session[:#{key}] = val\n end\n\n"
      end
    end
  end
end

##
# Temporary fix
#
module ScenarioAccessor
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def scenario_accessor(*args)
      scenario_reader(*args)
      scenario_writer(*args)
    end

    def scenario_reader(*args)
      opts = args.extract_options!
      args.each do |key|
        class_eval "def self.#{key}\n scenario.send(:#{key})\n end\n\n"
      end
    end

    def scenario_writer(*args)
      opts = args.extract_options!
      args.flatten.each do |key|
        class_eval "def self.#{key}=(val)\n scenario.send(:#{key}=, val)\n end\n\n"
      end
    end
  end
end

##
# Temporary fix
#
module SettingAccessor
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def setting_accessor(*args)
      setting_reader(*args)
      setting_writer(*args)
    end

    def setting_reader(*args)
      opts = args.extract_options!
      args.each do |key|
        class_eval "def self.#{key}\n setting.send(:#{key})\n end\n\n"
      end
    end

    def setting_writer(*args)
      opts = args.extract_options!
      args.flatten.each do |key|
        class_eval "def self.#{key}=(val)\n setting.send(:#{key}=, val)\n end\n\n"
      end
    end
  end
end