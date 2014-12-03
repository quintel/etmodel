class Api::ScaledArea < SimpleDelegator
  include Api::CommonArea

  DISABLED_FEATURES = [
    :has_agriculture, :has_industry, :has_other,
    :has_electricity_storage, :has_fce, :use_network_calculations
  ].freeze

  DISABLED_FEATURES.each do |feature|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{ feature }  ; false ; end
      def #{ feature }? ; false ; end
    RUBY
  end

  def attributes(*)
    super.tap do |data|
      DISABLED_FEATURES.each { |feature| data[feature.to_s] = false }
    end
  end

  def is_national_scenario
    false
  end
end # Api::ScaledArea
