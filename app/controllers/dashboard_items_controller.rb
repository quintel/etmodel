# frozen_string_literal: true

# Only show. Used when somebody clicks on an item in the dashboard. A detailed
# explaination of the dashboard item will pop up with a related chart.
class DashboardItemsController < ApplicationController
  def show
    @dashboard_item = DashboardItem.find(params[:id])
    render layout: false
  end
end
