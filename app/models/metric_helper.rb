module MetricHelper

  ##
  # Renders a fraction (0.0..1.0) into a percentage. E.g. (0.25 => 25%)
  #
  # @param value [Float] A fraction
  # @param options [Hash] options that are passed to format_number
  #
  def percentage(value, options = {})
    unless value.nil?
      options[:signed] = true unless options.has_key?(:signed)
      format_number(value * 100.0, options)
    end
  end

  def percentage_html(value, options = {})
    suffix percentage(value, options), '%'
  end

  ##
  # The performance/increase of two values.
  # e.g.
  # performance( 100, 150) => 50%
  #
  # @param value_old [Float] The older value (e.g. 2010)
  # @param value_new [Float] The newer value (e.g. 2040)
  # @param options [Hash] options that are passed to format_number
  #
  def performance(value_old, value_new, options = {})
    unless value_old.nil? or value_new.nil?
      value = (value_new / value_old) - 1
      percentage(value)
    end
  end

  def performance_html(value_old, value_new, options = {})
    suffix performance(value_old, value_new, options), '%'
  end


  ##
  # Displays a currency. Base is billions of euros.
  # e.g.
  #
  # @param value [Float] The value (e.g. 2010)
  # @param options [Hash] options that are passed to format_number
  #
  def currency(value, options = {})
    options[:unit] ||= EURO_SIGN
    # billion euros = 1000 ^ 3, therefore start_scale => 3
    scale, value = scaled_value(value, :start_scale => 3, :max_scale => 3)
    # suffix (
    prefix ' ' + format_number(value, :precision => 1).to_s, options[:unit]  #,  I18n.t(scaling_in_words(scale).to_s)
  end
  
  
  ##
  # Scales a value 
  # Some examples:
  # if it is 20000 million, you want 20 billion.
  # if it is 4000 million, you want 4000 million.
  # if a value is 0.1 billion you want 100 million
  #
  # @param value [Float] The value that must be scalled
  # @param options [Hash] options that are passed to scaled_value
  # @return Array [scale_factor, value]
  #
  def scaled_value(value, options = {})
    scale = options[:start_scale] ? options[:start_scale] : 0
    target = options[:target_scale] ? options[:target_scale] : nil
    max_scale = options[:max_scale] ? options[:max_scale] : (1.0/0) # max scale is billions of units
    min_scale = 0 # min scale is units
    value = value.to_f

    
    unless target
      # if value > 23000 e.g. make it 23.0
      # TODO: make 20000 optional, 10000 the default
      while value >= 20000 && scale < max_scale
        value = value / 1000
        scale += 1
      end
      # if value < 1, e.g. 0.1 make it 100
      while value < 1 && scale > min_scale
        value = value * 1000
        scale -= 1
      end
    else
      diff = target - scale
      diff.abs.times do
        up = diff < 0
        value = (up) ? (value * 1000) : (value / 1000)
        scale += (up) ? -1 : +1
      end
    end
    [scale, value]
  end

  # Translates a scale to a words:
  # 1000 ^ 1 = thousands
  # 1000 ^ 2 = millions
  # etc.
  #
  # @param scale [Float] The value that must be translated into a word
  def scaling_in_words(scale, options = {})
    unit = options[:unit]
    
    scale_symbol = case scale
      when 0
        :unit
      when 1
        :thousands
      when 2
        :millions
      when 3
        :billions
      when 4
        :trillions
      when 5
        :quadrillions
      when 6
        :quintillions  
    end
    
    I18n.t("units.%s.%s" % [unit.to_s, scale_symbol.to_s])
  end
  
  
  
  
  #
  # formats x out of y e.g.
  # out_of(2,12) => 2 / 12
  #
  def out_of(x, y)
    "#{x} / #{y}"
  end

  def x_country(country)
    #TODO: change region codes for provinces so this hack isnt needed
    if Current.scenario.region
      "x#{Current.scenario.region.gsub('nl-','')[0..2].upcase}"
    else
      "x#{Current.scenario.country.upcase}"
    end
  end
  ##
  # Apply common formatting options
  # :precision => rounding
  # :signed => true => adds a '+' sign if > 0
  #
  def format_number(value, options = {})
    unless value.nil?
      precision = options[:precision] || 1
      signed_value = options.has_key?(:signed) ? options[:signed] == true : false
      suffix = options[:suffix]

      return 'NaN' if value.respond_to?(:nan?) && value.nan?
      value = (value).round(precision)
      value = signed(value) if signed_value
      value = suffix(value, suffix) if suffix.present?
      value
    end
  end

  ##
  # prepends '+' sign if value is positive, '-' if negative, nothing if 0.0
  #
  # @param value [Numeric]
  # @return [String] "+5.1" or "-5.1"
  def signed(value)
    return value if value == 0.0
    value < 0.0 ? value : "+#{value}"
  end

  def suffix(value, suffix)
    unless value.nil?
      "#{value}<small>#{suffix}</small>".html_safe
    end
  end

  def prefix(value, prefix)
    unless value.nil?
      "<small>#{prefix}</small>#{value}".html_safe
    end
  end

end
