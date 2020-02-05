class RenameQueriesOtherIndustry < ActiveRecord::Migration[5.2]
  def up
    do_rename('aggregated_other_industry', 'other_non_specified_industry')
  end

  def down
    do_rename('other_non_specified_industry', 'aggregated_other_industry')
  end

  def do_rename(from, to)
    from_re = Regexp.escape(from)

    OutputElementSerie.find_each do |series|
      if series.gquery && series.gquery.include?(from)
        series.gquery = series.gquery.gsub(from_re, to)
        series.save(validate: false)
      end
    end

    OutputElement.find_each do |element|
      if element.key && element.key.include?(from)
        element.key = element.key.gsub(from_re, to)
        element.save(validate: false)
      end
    end
  end
end
