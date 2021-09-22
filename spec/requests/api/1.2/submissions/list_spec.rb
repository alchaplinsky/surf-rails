require 'rails_helper'
require_relative '../../v1/shared_examples'

describe 'API 1.2: Submissions#index' do
  let(:version) { 1.2 }
  let(:user) { create :user }
  let(:interest) { create :interest, user: user }
  let(:json) { MultiJson.load response.body }
  let(:api_token) { user.api_token }
  let(:headers) do
    {
      'X-Token' => api_token
    }
  end
  let!(:submission) do
    create(:submission, text: text, interest: interest, user: user, tag_list: ['idea', 'todo'])
  end
  let!(:params) do
    { headers: headers }
  end
  let(:text) { 'bla' }

  subject { get "/api/#{version}/interests/#{interest.id}/submissions", params }

  context 'unauthenticated user' do
    let(:api_token) { nil }

    it_behaves_like :unauthenticated_user
  end

  context 'authorized client' do
    context 'note submission' do
      let(:text) { 'This is cool snippet #fun #idea #google' }
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq({
          "results" => [{
            "id" => submission.id,
            "interest_id" => interest.id,
            "user_id" => user.id,
            "title" => nil,
            "text" => "This is cool snippet #fun #idea #google",
            "url" => share_url(submission.hashid),
            "link" => nil,
            "note" => nil,
            "image" => nil,
            "attachment" => nil,
            "tags" => [
              {
                "id" => submission.tags.first.id,
                "name" => "idea"
              }, {
                "id" => submission.tags.last.id,
                "name" => "todo"
              }
            ],
            "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
          }],
          "meta" => {
            "counters" => {
              "links" => 0,
              "notes" => 1,
              "images" => 0,
              "attachments" => 0
            },
            "pagination" => {
              "current_page" => 1,
              "is_first_page" => true,
              "is_last_page" => true,
              "total_count" => 1,
              "total_pages" => 1
            }
          }
        })
      end
    end

    context 'submission with link' do
      let!(:link) do
        create :link,
          submission: submission,
          title: 'Google',
          description: 'Google',
          image: 'https://assets-cdn.github.com/images/modules/open_graph/github-logo.png',
          url: 'https://google.com',
          domain: 'google.com'
      end
      let(:text) { 'This is cool snippet https://google.com #fun #idea #google' }
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq({
          "results" => [{
            "id" => submission.id,
            "interest_id" => interest.id,
            "user_id" => user.id,
            "title" => nil,
            "text" => "This is cool snippet https://google.com #fun #idea #google",
            "url" => "https://google.com",
            "link" => {
              "title" => "Google",
              "url" => "https://google.com",
              "domain" => "google.com",
              "description" => "Google",
              "image" => "https://assets-cdn.github.com/images/modules/open_graph/github-logo.png"
            },
            "note" => nil,
            "image" => nil,
            "attachment" => nil,
            "tags" => [
              {
                "id" => submission.tags.first.id,
                "name" => "idea"
              }, {
                "id" => submission.tags.last.id,
                "name" => "todo"
              }
            ],
            "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
          }],
          "meta" => {
            "counters" => {
              "links" => 1,
              "notes" => 0,
              "images" => 0,
              "attachments" => 0
            },
            "pagination" => {
              "current_page" => 1,
              "is_first_page" => true,
              "is_last_page" => true,
              "total_count" => 1,
              "total_pages" => 1
            }
          }
        })
      end
    end

    context 'submission with image' do
      let!(:image) do
        create :image,
          submission: submission,
          title: '1.jpg',
          url: 'https://example.com/1.jpg',
          domain: 'example.com'
      end
      let(:text) { 'This is cool snippet https://example.com/1.jpg #fun #idea #google' }
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq({
          "results" => [{
            "id" => submission.id,
            "interest_id" => interest.id,
            "user_id" => user.id,
            "title" => nil,
            "text" => "This is cool snippet https://example.com/1.jpg #fun #idea #google",
            "url" => "https://example.com/1.jpg",
            "image" => {
              "title" => "1.jpg",
              "url" => "https://example.com/1.jpg",
              "domain" => "example.com",
            },
            "note" => nil,
            "link" => nil,
            "attachment" => nil,
            "tags" => [
              {
                "id" => submission.tags.first.id,
                "name" => "idea"
              }, {
                "id" => submission.tags.last.id,
                "name" => "todo"
              }
            ],
            "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
          }],
          "meta" => {
            "counters" => {
              "links" => 0,
              "notes" => 0,
              "images" => 1,
              "attachments" => 0
            },
            "pagination" => {
              "current_page" => 1,
              "is_first_page" => true,
              "is_last_page" => true,
              "total_count" => 1,
              "total_pages" => 1
            }
          }
        })
      end
    end

    context 'attachment with image' do
      let!(:attachment) do
        create :attachment,
          submission: submission,
          title: '1.pdf',
          format: 'pdf',
          url: 'https://example.com/1.pdf',
          domain: 'example.com'
      end
      let(:text) { 'This is cool snippet https://example.com/1.pdf #fun #idea #google' }
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq({
          "results" => [{
            "id" => submission.id,
            "interest_id" => interest.id,
            "user_id" => user.id,
            "title" => nil,
            "text" => "This is cool snippet https://example.com/1.pdf #fun #idea #google",
            "url" => "https://example.com/1.pdf",
            "attachment" => {
              "title" => "1.pdf",
              "format" => "pdf",
              "url" => "https://example.com/1.pdf",
              "domain" => "example.com",
            },
            "note" => nil,
            "link" => nil,
            "image" => nil,
            "tags" => [
              {
                "id" => submission.tags.first.id,
                "name" => "idea"
              }, {
                "id" => submission.tags.last.id,
                "name" => "todo"
              }
            ],
            "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
          }],
          "meta" => {
            "counters" => {
              "links" => 0,
              "notes" => 0,
              "images" => 0,
              "attachments" => 1
            },
            "pagination" => {
              "current_page" => 1,
              "is_first_page" => true,
              "is_last_page" => true,
              "total_count" => 1,
              "total_pages" => 1
            }
          }
        })
      end
    end
  end
end
