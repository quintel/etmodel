class RenameBioResiduesForFiring < ActiveRecord::Migration
  def up
    do_rename('bio_residues_for_firing', 'woody_biomass')
  end

  def down
    do_rename('woody_biomass', 'bio_residues_for_firing')
  end

  def do_rename(from, to)
    from_re = /#{ Regexp.escape(from) }/

    OutputElementSerie.find_each do |series|
      if series.gquery && series.gquery.include?(from)
        series.gquery.gsub(from_re, to)
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
