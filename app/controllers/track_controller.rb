class TrackController < ApplicationController
  def track
    Tracker.instance.track params[:data], current_user
    render :text => 'ok'
  end
end
