class FactsheetsController < ApplicationController
  layout 'factsheet'

  def show
    @scenario = Api::Scenario.find(params[:id])
  end
end
