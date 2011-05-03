module NumbersHelper
  
  def detailed_number(n)
    return n unless n.is_a?(Numeric)
    capture_haml do
      haml_tag :'span.detailed_number', :title => number_with_delimiter(n) do
        haml_concat(auto_number(n))
      end
    end
  end


  # TODO refactor (seb 2010-10-11)
  def auto_number(value)
    return '-' if value.nil?
    return 'Infinity' if value.to_f.infinite?

    if value > 10**8
      number_with_precision(value.to_f / 10**9, :precision => 2, :delimiter => ",") + " B"
    elsif value > 10**5
      number_with_precision(value.to_f / 10**6, :precision => 2, :delimiter => ",") + " M"
    elsif value > 10**2
      number_with_precision(value.to_f / 10**3, :precision => 2, :delimiter => ",") + " K"
    elsif value > 0 && value < 100
      number_with_precision value, :precision => 2
    else
      value
    end
  end

  def billion(value)
    if value and value.abs.to_f > 10**9
      m = value.to_f / 10**9
      number_with_precision(m, :precision => 1, :delimiter => ",") + " B"
    else
      million value
    end
  end

  def million(value)
    if value and value.abs.to_f > 10**6
      m = value.to_f / 10**6
      number_with_precision(m, :precision => 1, :delimiter => ",") + " M"
    else
      value
    end
  end

  def thousand(value)
    if value and value.abs.to_f > 10**3
      m = value.to_f / 10**3
      number_with_precision(m, :precision => 1, :delimiter => ",") + " K"
    else
      value
    end
  end

end