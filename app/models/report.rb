# frozen_string_literal: true

# Contains features used to generate scenario reports and summaries.
module Report
  REPORTS_DIR = Rails.root.join('config/reports').freeze

  # Public: Returns the string content of the named report for the given locale.
  #
  # For example:
  #   Report.find('main', 'en')
  #   # => loads config/reports/main.en.liquid
  #
  # name   - The name of the report.
  # locale - Which language to use.
  #
  # Returns a string, or raises ActiveRecord::RecordNotFound.
  def self.find(name, locale)
    path = REPORTS_DIR.join([name, locale, 'liquid'].compact.join('.'))

    unless path.file?
      raise ActiveRecord::RecordNotFound, "No such report: #{ path }"
    end

    path.read
  end
end
