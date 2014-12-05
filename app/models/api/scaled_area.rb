class Api::ScaledArea < SimpleDelegator
  include Api::CommonArea

  # Area features which are disabled in the ETM front-end for all scaled
  # scenarios.
  DISABLED_FEATURES = [
    :has_other, :has_electricity_storage, :has_fce, :use_network_calculations
  ].freeze

  # Area features which may be turned on or off by the user when the start a new
  # scaled scenario.
  OPTIONAL_FEATURES = [
    :has_agriculture, :has_industry
  ]

  DISABLED_FEATURES.each do |feature|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{ feature }  ; false ; end
      def #{ feature }? ; false ; end
    RUBY
  end

  OPTIONAL_FEATURES.each do |feature|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{ feature }
        Current.setting[:scaling] && Current.setting[:scaling][:#{ feature }]
      end

      alias_method :#{ feature }?, :#{ feature }
    RUBY
  end

  def attributes(*)
    super.tap do |data|
      (DISABLED_FEATURES + OPTIONAL_FEATURES).each do |feature|
        data[feature.to_s] = public_send(feature)
      end
    end
  end

  def is_national_scenario
    false
  end
end # Api::ScaledArea
