class UsersFilteringService

  def initialize(params)
    @params = params
  end

  def users
    return [] if @params['query'].blank?
    User.by_name_or_email(query)
  end

  private

  def query
    "#{@params['query']}%"
  end

end
