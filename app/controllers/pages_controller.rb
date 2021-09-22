class PagesController < ApplicationController

  layout 'landing'

  before_action :build_download_data, only: [:index, :download, :features]

  def index
     @skip_footer = true
  end

end
