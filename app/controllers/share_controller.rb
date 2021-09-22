class ShareController < ApplicationController
  def show
    @submission = Submission.find_by_hashid(params[:hashid])
  end
end
