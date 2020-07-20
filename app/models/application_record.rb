# frozen_string_literal: true

# Base ActiveRecord class for all models.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
