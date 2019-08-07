class FixZeroedTimestampValues < ActiveRecord::Migration[5.2]
  INVALID_DATE = '0000-00-00 00:00:00'

  def up
    # Some rows belonging to these models contain a created_at or updated_at
    # of 0000-00-00 00:00:00, which is clearly invalid and prevents changing the
    # charset/collation of the table.
    [InputElement, OutputElementSerie, OutputElementType, OutputElement, Slide].each do |klass|
      klass.where('created_at IS NULL OR created_at = ?', INVALID_DATE).each do |model|
        model.created_at = 7.years.ago
        model.save(validate: false, touch: false)
      end

      klass.where('updated_at IS NULL OR updated_at = ?', INVALID_DATE).each do |model|
        if model.created_at
          model.updated_at = model.created_at
        else
          model.updated_at = 7.years.ago
        end

        model.save(validate: false, touch: false)
      end
    end
  end

  def down
    # Do nothing
  end
end
