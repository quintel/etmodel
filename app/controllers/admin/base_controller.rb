module Admin
  class BaseController < ApplicationController
    layout 'admin'
    before_action :restrict_to_admin
  end
end
