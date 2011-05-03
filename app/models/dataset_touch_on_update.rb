##
# Common methods for classes that depend on dataset.
# such as ConverterData, SlotData, etc.
#
#
module DatasetTouchOnUpdate
  def self.included(klass)
    # Mark dataset as updated for caching purposes.
    klass.after_save :touch_dataset
  end

  ##
  # Mark dataset as updated when we update a record.
  #
  def touch_dataset
    dataset.touch
  end
end