class TabController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser,
                :load_view_settings,
                :ensure_settings_defined,
                :store_last_etm_page,
                :load_output_element,
                :preload_gql

  def show
    show_intro_at_least_once
  end

  def load_output_element
    @output_element = Current.view.default_output_element_for_sidebar_item
  end
end