module DeviseFeatureHelpers
  def login(user)
    login_as user
    user
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.include Devise::TestHelpers, type: :controller
  config.include DeviseFeatureHelpers, type: :feature
end
