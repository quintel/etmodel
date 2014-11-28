class Api::ScaledArea < SimpleDelegator
  include Api::CommonArea

  DISABLED_SECTORS = [
    :agriculture, :industry, :other, :electricity_storage, :fce
  ].freeze

  DISABLED_SECTORS.each do |sector|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def has_#{ sector }  ; false ; end
      def has_#{ sector }? ; false ; end
    RUBY
  end

  def attributes(*)
    super.tap do |data|
      DISABLED_SECTORS.each { |sector| data["has_#{ sector }"] = false }
    end
  end

  def is_national_scenario
    false
  end
end # Api::ScaledArea
