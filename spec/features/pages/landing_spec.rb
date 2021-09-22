require 'rails_helper'

feature 'User visits landing page', js: true do

  context 'not authenticated user' do
    Steps 'Users sees login and signup menu items' do
      When 'I go to main page' do
        visit root_path
      end
      Then 'I see navigation for unauthenticated user' do
        should_see_link 'Home', '/'
        should_see_link 'Download', '/download'
        should_see_link 'Login', new_user_session_path
        should_see_link 'Sign up', new_user_registration_path
      end
    end
  end

  context 'user is authenticated' do
    let!(:user) { create(:user) }
    before { login user }

    Steps 'Users sees login and signup menu items' do
      When 'I go to main page' do
        visit root_path
      end
      Then 'I see navigation for unauthenticated user' do
        should_see_link 'Home', '/'
        should_see_link 'Download', '/download'
        should_see_link 'Dashboard', dashboard_path
      end
    end
  end

  context 'Mac OS platform' do
    Steps 'User succesfully visits main page' do
      Given 'I am on Mac OS' do
        page.driver.header('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko)')
      end
      When 'I go to main page' do
        visit root_path
      end
      Then 'I should see main page navigation' do
        should_see "Organize your ideas & inspirations"
      end
      And 'I should see download button' do
        should_see 'Available for MacOS 10.8+'
        should_see_link 'Join Surf Now', new_user_registration_path
        should_see_link 'Free Download', 'https:/surfapp.io/download/mac/Surf-0.1.0.dmg'
      end
    end
  end

  context 'Windows platform' do
    Steps 'User succesfully visits main page' do
      Given 'I am on Windows' do
        page.driver.header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36')
      end
      When 'I go to main page' do
        visit root_path
      end
      Then 'I should see main page navigation' do
        should_see "Organize your ideas & inspirations"
      end
      And 'I should see download button' do
        should_see 'Available for Windows 7+'
        should_see_link 'Join Surf Now', new_user_registration_path
        should_see_link 'Free Download', 'https:/surfapp.io/download/windows/Surf-0.1.0.exe'
      end
    end
  end
end
