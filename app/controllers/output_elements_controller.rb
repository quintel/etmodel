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
    Rails.logger.info "Received request for CSV download for OutputElement ID: #{@chart.id}"
    csv_data = @chart.to_csv
    respond_to do |format|
      format.csv { send_data csv_data, filename: "#{@chart.name}.csv" }
    end
  end

  def zoom
  end

  private

  def find_output_element
    @as_table = params[:format] == 'table'

    @chart = OutputElement.find!(params[:key])
  end
end
