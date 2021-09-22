class Api::SubmissionsController < Api::BaseController

  before_action :find_interest
  before_action :find_submission, only: [:show, :update, :destroy]

  def index
    @posts = find_interest_submissions
    if api_version == 1.2
      render json: SubmissionsService.new(@interest.submissions, params).to_json
    else
      render json: presenter_class[api_version].map(@posts)
    end
  end

  def show
    render json: Api::SubmissionPresenter[api_version].new(@submission)
  end

  def create
    @service = Submission::CreationService.new(@interest, submission_params)
    if @service.create
      #NotificationBroadcastJob.perform_now @service.submission, current_user, :create
      render json: Api::SubmissionPresenter[api_version].new(@service.submission)
    else
      render_error Api::Errors::ValidationPresenter[api_version].new(@service.submission.errors.messages)
    end
  end

  def update
    authorize @submission
    @service = Submission::UpdatingService.new(@submission, submission_params, api_version)
    if @service.update
      render json: Api::SubmissionPresenter[api_version].new(@service.submission)
    else
      render_error Api::Errors::ValidationPresenter[api_version].new(@service.submission.errors.messages)
    end
  end

  def destroy
    authorize @submission
    @submission.destroy
    render json: Api::SubmissionPresenter[api_version].new(@submission)
  end

private

  def find_interest
    @interest = current_user.interests.find params[:interest_id]
  end

  def find_submission
    @submission = @interest.submissions.find(params[:id])
  end

  def find_interest_submissions
    @interest.submissions
      .preload(:user)
      .includes(:link, :note, :image, :attachment, :tags)
      .order('created_at')
  end

  def submission_params
    params.require(:submission).permit(
      :text,
      :tag_list,
      link_attributes: [:title, :description],
      note_attributes: [:title, :text],
      image_attributes: [:title],
      attachment_attributes: [:title]
    ).merge!(user_id: current_user.id)
  end

  def presenter_class
    if @interest.shared?
      Api::ExtendedSubmissionPresenter
    else
      Api::SubmissionPresenter
    end
  end

end
