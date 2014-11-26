class Api::ScaledArea < SimpleDelegator
  DISABLED_SECTORS = [ :agriculture, :industry ].freeze

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
end # Api::ScaledArea
