# frozen_string_literal: true

module API
  # Allows users to view, add, update, and remove their transition paths.
  class TransitionPathsController < APIController
    before_action :verify_token!

    before_action(only: %i[index show])    { verify_scopes!(%w[scenarios:read]) }
    before_action(only: %i[create update]) { verify_scopes!(%w[scenarios:read scenarios:write]) }
    before_action(only: %i[destroy])       { verify_scopes!(%w[scenarios:read scenarios:delete]) }

    def index
      page = (params[:page].presence || 1).to_i
      limit = (params[:limit].presence || 25).to_i.clamp(1, 100)

      @pagy, paths = pagy(
        current_user.multi_year_charts
          .includes(:scenarios)
          .order(created_at: :desc),
        items: limit,
        page: page
      )

      render json: PaginationSerializer.new(
        pagy: @pagy,
        collection: paths,
        serializer: ->(item) { item },
        url_for: ->(page, limit) { api_transition_paths_url(page: page, limit: limit) }
      )
    end

    def show
      render json: current_user.multi_year_charts.includes(:scenarios).find(params.require(:id))
    end

    def create
      CreateTransitionPath.new.call(
        user: current_user,
        params: params.permit!.to_h
      ).either(
        ->(path)   { render json: path, status: :created },
        ->(errors) { render json: errors, status: :unprocessable_entity }
      )
    end

    def update
      UpdateTransitionPath.new.call(
        transition_path: current_user.multi_year_charts.find(params.require(:id)),
        params: params.permit!.to_h
      ).either(
        ->(path)   { render json: path, status: :ok },
        ->(errors) { render json: errors, status: :unprocessable_entity }
      )
    end

    def destroy
      current_user.multi_year_charts.find(params.require(:id)).destroy
      head :ok
    end
  end
end
