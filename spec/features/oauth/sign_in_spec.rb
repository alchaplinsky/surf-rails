require 'rails_helper'

feature 'User sig in via Oauth', js: true do

  given!(:user) do
    create :user,
      provider: provider,
      uid: '123456',
      first_name: first_name,
      last_name: last_name
  end

  background do
    ExternalRequestSupport.mock_remote_image('https://placehold.it/200x200')
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
      provider: provider,
      uid: '123456',
      info: {
        name: "#{first_name} #{last_name}",
        first_name: first_name,
        last_name: last_name,
        email: 'john.doe@example.com',
        image: "https://placehold.it/200x200"
      }
    })
    When 'I visit landing page' do
      visit root_path
    end
    Then 'I should see authentication links' do
      within '.navigation' do
        should_see_link 'Login', new_user_session_path
        should_see_link 'Sign up', new_user_registration_path
      end
    end
    And 'I click sign up' do
      click_link 'Login'
    end
    Then 'I should see signup options' do
      within '.authentication' do
        should_see 'Log In'
        should_see_link 'Log in with Facebook', user_facebook_omniauth_authorize_path
        should_see_link 'Log in with Google', user_google_oauth2_omniauth_authorize_path
        should_see 'Don\'t have an account? Sign up now ›'
        should_see_link 'Sign up now ›', new_user_registration_path
      end
    end
  end

  context 'Facebook provider' do
    given(:provider) { 'facebook' }
    given(:first_name) { 'John' }
    given(:last_name) { 'Doe' }

    Steps 'User signs in via facebook' do
      When 'I click login' do
        click_link 'Log in with Facebook'
      end
      Then 'I should be logged in' do
        within '.account' do
          should_see 'John Doe'
        end
      end
      And 'I should be loacated on dashboard' do
        should_be_located dashboard_path
      end
    end
  end

  context 'User signs in via Google' do
    given(:provider) { 'google_oauth2' }
    given(:first_name) { 'Jack' }
    given(:last_name) { 'Black' }

    Steps 'User signs in via google' do
      When 'I click login' do
        click_link 'Log in with Google'
      end
      Then 'I should be logged in' do
        within '.account' do
          should_see 'Jack Black'
        end
      end
      And 'I should be loacated on dashboard' do
        should_be_located dashboard_path
      end
    end
  end
end
