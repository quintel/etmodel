class OutputElementsController < ApplicationController
  layout false

  before_action :find_output_element, only: [:show, :zoom]

  # Returns all the data required to show a chart.
  # JSON only
  def show
    json = OutputElementPresenter.present(
      @chart, ->(*args) { render_to_string(*args) }
    )

    render(status: :ok, json: json)
  end

  # Returns all the data required to show multiple charts. Renders a JSON object
  # where each key matches that of the requested chart.
  def batch
    ids = params[:ids].to_s.split(',').reject(&:blank?).uniq

    json = OutputElementPresenter.collection(
      OutputElement.where(id: ids),
      ->(*args) { render_to_string(*args) }
    )

    render(status: :ok, json: json)
  end

  def index
    # id of the element the chart will be placed in
    @chart_holder = params[:holder]
    @groups = OutputElement.not_hidden.select_by_group
  end

  # legacy actions used by the block charts
  #
  def invisible
    session[params[:id]] = 'invisible'
    render js: ""
  end

  def visible
    session[params[:id]] = 'visible'
    render js: ""
  end

  def zoom
  end

  private

  def find_output_element
    @as_table = params[:format] == 'table'

    @chart =
      if params[:id] && params[:id] =~ /\D/
        OutputElement.find_by_key!(params[:id])
      else
        OutputElement.find(params[:id])
      end
  end
end
