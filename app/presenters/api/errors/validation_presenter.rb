class Api::Errors::ValidationPresenter < BasePresenter

  attributes :type, :errors

  def type
    'validation'
  end

  def errors
    object
  end

end
