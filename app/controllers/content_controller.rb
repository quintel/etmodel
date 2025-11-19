# frozen_string_literal: true

class ContentController < ApplicationController
  include ApplicationHelper

  layout 'static_page'
  skip_before_action :initialize_current

  def releases
    redirect_to(releases_external_url, allow_other_host: true)
  end
  alias_method :whats_new, :releases
end
