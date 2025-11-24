# frozen_string_literal: true

class ContentController < ApplicationController
  include ApplicationHelper

  layout 'static_page'
  skip_before_action :initialize_current
end
