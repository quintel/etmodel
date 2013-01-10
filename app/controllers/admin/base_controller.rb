module Admin
  class BaseController < ApplicationController
    layout 'admin'
    before_filter :restrict_to_admin
  end
end
