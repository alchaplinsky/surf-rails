class DashboardController < ApplicationController

  before_action :require_user!
  before_action :build_download_data

  def show
  end

end
