require 'rails_helper'

feature 'User signup via Oauth', js: true do
  before do
    ExternalRequestSupport.mock_remote_image('https://placehold.it/200x200')
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123456',
      info: {
        name: 'John Doe',
        email: email,
        image: "https://placehold.it/200x200"
      }
    })
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        name: 'John Doe',
        first_name: 'John',
        last_name: 'Doe',
        email: email,
        image: "https://placehold.it/200x200"
      }
    })
  end

  given(:user) { User.last }
  given(:email) { 'johndoe@gmail.com' }

  shared_steps :user_is_on_dashboard do
    And 'I should be on dashboard' do
      should_be_located dashboard_path
    end
    And 'I should see instructions' do
      should_see 'You\'re almost there!'
      should_see 'There is only one simple step left. Download desktop application and start using Surf!'
    end
    And 'User should be created' do
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Doe')
      expect(user.email).to eq('johndoe@gmail.com')
      expect(user.uid).to eq('123456')
    end
    And 'default interest should be created' do
      expect(user.own_interests.size).to eq 1
      expect(user.own_interests.first.name).to eq 'getting_started'
    end
  end

  shared_steps :user_completes_registration do |auth_path|
    Then 'I should see enter email form' do
      should_see 'Hello, John Doe'
    end
    And 'I should be on complete page' do
      should_be_located auth_path
    end
    When 'I try to submit empty form' do
      click_button 'Create Account'
    end
    Then 'I should still be on complete form' do
      should_see 'Hello, John Doe'
      should_see_element ".field_with_errors"
    end
    When 'I enter my email' do
      fill_in "user_email", with: 'johndoe@gmail.com'
    end
    And 'I submit form' do
      click_button 'Create Account'
    end
    Then 'I should see success message' do
      should_see 'Successfully created account'
    end
  end

  context 'User signs up via landing page' do
    background do
      When 'I visit landing page' do
        visit root_path
      end
      Then 'I should see authentication links' do
        within '.navigation' do
          should_see_link 'Login', new_user_session_path
          should_see_link 'Sign up', new_user_registration_path
        end
        should_see_link 'Join Surf Now', new_user_registration_path
      end
      And 'I click sign up' do
        click_link 'Sign up'
      end
      Then 'I should see signup options' do
        within '.authentication' do
          should_see 'Sign Up'
          should_see_link 'Sign up with Facebook', user_facebook_omniauth_authorize_path
          should_see_link 'Sign up with Google', user_google_oauth2_omniauth_authorize_path
          should_see 'Already have an account? Log in now ›'
          should_see_link 'Log in now ›', new_user_session_path
        end
      end
    end

    context 'Facebook oauth' do
      context 'user email is returned from facebook' do
        Steps 'User succesfully signs up with Facebook' do
          When 'I click signup with Facebook' do
            click_link 'Sign up with Facebook'
          end
          Then 'I should see success message' do
            should_see 'Successfully authenticated from Facebook account'
          end

          include_steps :user_is_on_dashboard
        end
      end

      context 'user email is not in response' do
        given(:email) { nil }

        Steps 'User succesfully signs up by providing email' do
          When 'I click signup with Facebook' do
            click_link 'Sign up with Facebook'
          end
          include_steps :user_completes_registration, '/users/auth/facebook/callback'
          include_steps :user_is_on_dashboard
        end
      end

      context 'Google oauth' do
        context 'user email is returned from google' do
          Steps 'User succesfully signs up with Google' do
            When 'I click signup with Google' do
              click_link 'Sign up with Google'
            end
            Then 'I should see success message' do
              should_see 'Successfully authenticated from Google account'
            end

            include_steps :user_is_on_dashboard
          end
        end
        context 'user email is not in response' do
          given(:email) { nil }

          Steps 'User succesfully signs up by providing email' do
            When 'I click signup with Google' do
              click_link 'Sign up with Google'
            end
            include_steps :user_completes_registration, '/users/auth/google_oauth2/callback'
            include_steps :user_is_on_dashboard
          end
        end
      end
    end
  end

  context 'users signs up via invitation' do
    given!(:invite) do
      create :invite, email: 'johndoe@gmail.com', status: 'pending'
    end

    context 'Facebook provider' do
      background do
        When 'I visit invitation page' do
          visit invite_path(invite.token)
        end
        And 'I click join surf button' do
          within '.container .by-center' do
            click_link 'Sign up with Facebook'
          end
        end
      end

      context 'user email is returned from facebook' do
        Steps 'Invite gets accepted' do
          Then 'I should see success message' do
            should_see 'Successfully authenticated from Facebook account'
          end

          include_steps :user_is_on_dashboard

          And 'Invite gets accepted' do
            expect(invite.reload.status).to eq('accepted')
          end
        end
      end

      context 'user email is not returned from facebook' do
        given(:email) { nil }

        Steps 'Invite gets accepted' do
          include_steps :user_completes_registration, '/users/auth/facebook/callback'

          include_steps :user_is_on_dashboard

          And 'Invite gets accepted' do
            expect(invite.reload.status).to eq('accepted')
          end
        end
      end
    end

    context 'Google provider' do
      background do
        When 'I visit invitation page' do
          visit invite_path(invite.token)
        end
        And 'I click join surf button' do
          within '.container .by-center' do
            click_link 'Sign up with Google'
          end
        end
      end

      context 'user email is returned from google' do
        Steps 'Invite gets accepted' do
          Then 'I should see success message' do
            should_see 'Successfully authenticated from Google account'
          end

          include_steps :user_is_on_dashboard

          And 'Invite gets accepted' do
            expect(invite.reload.status).to eq('accepted')
          end
        end
      end

      context 'user email is not returned from google' do
        given(:email) { nil }

        Steps 'Invite gets accepted' do
          include_steps :user_completes_registration, '/users/auth/google_oauth2/callback'

          include_steps :user_is_on_dashboard

          And 'Invite gets accepted' do
            expect(invite.reload.status).to eq('accepted')
          end
        end
      end
    end
  end
end
