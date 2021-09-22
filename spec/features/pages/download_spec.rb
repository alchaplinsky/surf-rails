require 'rails_helper'

feature 'User visits download page', js: true do

  context 'Mac OS platform' do
    Steps 'User succesfully visits main page' do
      Given 'I am on Mac OS' do
        page.driver.header('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko)')
      end
      When 'I go to main page' do
        visit download_path
      end
      Then 'I should see main page navigation' do
        should_see 'Get Surf for Desktop'
        should_see 'Download and install Surf desktop app for MacOS or Windows. Also available Surf chrome extension.'
      end
      And 'I should see download button' do
        should_see_link 'Download Surf for Mac', 'https:/surfapp.io/download/mac/Surf-0.1.0.dmg'
        should_see 'Current version: v0.1.0'
      end
      And 'I should see other download links' do
        within '.section .col1of3:nth-child(1)' do
          should_see 'Mac OS'
          should_see_link 'Download for Mac 10.8+', 'https:/surfapp.io/download/mac/Surf-0.1.0.dmg'
          should_see 'Current version: v0.1.0'
        end
        within '.section .col1of3:nth-child(2)' do
          should_see 'Windows'
          should_see_link 'Download for Windows 7+', 'https:/surfapp.io/download/windows/Surf-0.1.0.exe'
          should_see 'Current version: v0.1.0'
        end
        within '.section .col1of3:nth-child(3)' do
          should_see 'Chrome Extension'
          should_see_link 'Download Surf for Chrome', 'https://chrome.google.com/webstore/detail/surf/poepphjbhofpmdfkcjhhlocidhhmiega'
        end
      end
    end
  end

  context 'Windows platform' do
    Steps 'User succesfully visits main page' do
      Given 'I am on Windows' do
        page.driver.header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36')
      end
      When 'I go to main page' do
        visit download_path
      end
      Then 'I should see main page navigation' do
        should_see 'Get Surf for Desktop'
      end
      And 'I should see download button' do
        should_see_link 'Download Surf for Windows', 'https:/surfapp.io/download/windows/Surf-0.1.0.exe'
        should_see 'Current version: v0.1.0'
      end
      And 'I should see other download links' do
        save_screenshot('./tmp/1.png')
        within '.section .col1of3:nth-child(1)' do
          should_see 'Mac OS'
          should_see_link 'Download for Mac 10.8+', 'https:/surfapp.io/download/mac/Surf-0.1.0.dmg'
          should_see 'Current version: v0.1.0'
        end
        within '.section .col1of3:nth-child(2)' do
          should_see 'Windows'
          should_see_link 'Download for Windows 7+','https:/surfapp.io/download/windows/Surf-0.1.0.exe'
          should_see 'Current version: v0.1.0'
        end
        within '.section .col1of3:nth-child(3)' do
          should_see 'Chrome Extension'
          should_see_link 'Download Surf for Chrome', 'https://chrome.google.com/webstore/detail/surf/poepphjbhofpmdfkcjhhlocidhhmiega'
        end
      end
    end
  end
end
