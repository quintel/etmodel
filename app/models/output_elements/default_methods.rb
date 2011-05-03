class OutputElement < ActiveRecord::Base
  include Colors

  def colors
    allowed_output_element_series.map do |serie|
      convert_color(serie.color)
    end
  end

  def series
    series = []
    allowed_output_element_series.each do |serie|
      result = Current.gql.query(serie.key)
      series << result.map{|year,value| [year,value]}
    end

    start_scale = 3

    # smallest_scale    
    smallest_scale = Metric.scaled_value([
      series.map{|present,future| [ present.last]}.flatten.sum,
      series.map{|present,future|[ future.last]}.flatten.sum].min,
      :start_scale => start_scale).first

    series = series.map{|x| x.map{|year,value| [
      year,
      Metric.scaled_value(value,
        :start_scale => start_scale, 
        :target_scale => smallest_scale).last]
      }
    }

    unit = parsed_unit(smallest_scale)

    [series,unit]
  end

  def labels
    allowed_output_element_series.map do |serie|
      I18n.t("serie.#{serie.label}")
    end
  end

  # Used for Mekko and Waterfall
  #
  def number_of_ticks
    min = @options[2][0]
    max = @options[2][1]
    min_value = min.abs
    max_value = max.abs
    tick_size = calculate_tick_size((min_value > max_value) ? min_value : max_value)
    ticks_positive = (max_value / tick_size).ceil
    ticks_negative = (min_value / tick_size).ceil
    if (ticks_positive + ticks_negative) > 10
      ticks_negative /= 2
      ticks_positive /= 2
      tick_size *= 2
    end
    @options[2][0] = ticks_negative * tick_size * -1
    @options[2][1] = ticks_positive * tick_size
    total_ticks = ticks_positive + ticks_negative +1
    return [total_ticks,tick_size]  
  end

  def calculate_tick_size(value)

    length = value.to_i.to_s.length # get length of number without decimals

    length = (length - 1) unless length == 1 #
    divider = 10 ** length
    ticks = value.to_f / divider
    ticks *= 5 if ticks < 2
    tick_size = value / ticks
    tick_size
  end 

  def axis_values
    if percentage
      #check if percentage is negative
      # SEB: never runs: @options.first.to_a.flatten.max < 0
      #      because @options.first => [[2010, x], [2050, y]]. 2010 is never < 2010
      # if @options.first.to_a.flatten.max < 0 && output_element_type.name != "policy_bar"
      #   [axis_scale(@options.first.first.min * -1) * -1,0]
      # else
        [0,100]
      # end
    else
      total_current = 0
      total_future = 0
      min_value = 0
      max_value = 0

      total_current = @options.first.map{|present,future| present.last > 0 ? present.last : 0}.sum
      total_future = @options.first.map{|present,future| future.last > 0 ? future.last : 0}.sum

      max_value = ((total_future > total_current) ? total_future : total_current)
      max_value += (max_value * 0.1)
      # SEB if not necessary. min_value is assigned 0, therefore never < 0
      if min_value < 0
        min_value = axis_scale(min_value * -1) * -1
      end

      [min_value,axis_scale(max_value)]
    end
  end

  private

  def parsed_unit(scale = nil)
    if unit == "PJ"
      Metric.scaling_in_words(scale, :unit => :joules)
    elsif unit == "MT"
      Metric.scaling_in_words(scale, :unit => :ton)
    elsif unit == "EUR"
      Metric.scaling_in_words(scale, :unit => :currency)
    else
      unit
    end
  end

  def axis_scale(total)

    total = total.to_i
    length = total.to_s.length
    #length = (total / 10).to_i + 1
    length = (length - 1) unless length == 1
    tick_size = 10 ** length
    ratio = (total.to_f / 5) / tick_size.to_f
    if ratio < 0.025
      result = tick_size * 0.05
    # REFACTOR: ratio >= 0.1 is not needed
    # [0.1, 0.5, 1.0].each do |factor|
    elsif ratio >= 0.025 && ratio < 0.05
      result = tick_size * 0.1

    elsif ratio >= 0.05 && ratio < 0.1
      result = tick_size * 0.1
    elsif ratio >= 0.1 && ratio < 0.5
      result = tick_size * 0.5
    elsif ratio >= 0.5 && ratio < 1
      result = tick_size
    elsif ratio >= 1 && ratio < 1.5
      result = tick_size * 1.5
    elsif ratio >= 1.50 && ratio  < 2
      result = tick_size * 2
    end
    return result * 5
  end
end
