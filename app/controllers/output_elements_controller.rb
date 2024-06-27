class OutputElementsController < ApplicationController
  layout false

  before_action :find_output_element, only: [:show, :zoom, :data_csv]

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
    keys = params[:keys].to_s.split(',').reject(&:blank?).uniq

    json = OutputElementPresenter.collection(
      keys.map { |key| OutputElement.find(key) },
      ->(*args) { render_to_string(*args) }
    )

    render(status: :ok, json: json)
  end

  def index
    # id of the element the chart will be placed in
    @chart_holder = params[:holder]
    @groups = OutputElement.select_by_group

    respond_to do |wants|
      wants.html {}
      wants.json { render(json: GroupedOutputElementPresenter.new(@groups)) }
    end
  end

  def data_csv
    @chart = OutputElement.find_by!(key: params[:key])
    presenter = OutputElementPresenter.new(@chart, ->(*args) { render_to_string(*args) })
    csv_data = presenter.to_csv

    respond_to do |format|
      format.csv { send_data csv_data, filename: "#{params[:key]}.csv" }
    end
  rescue => e
    logger.error "Failed to generate CSV: #{e.message}"
    render plain: "Failed to generate CSV", status: :internal_server_error
  end

  def zoom
  end

  private

  def find_output_element
    @as_table = params[:format] == 'table'

    @chart = OutputElement.find!(params[:key])
  end
end
