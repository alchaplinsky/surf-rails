require 'rails_helper'
require_relative 'shared_examples'

describe 'Submissions' do
  let(:user) { create :user }
  let(:interest) { create :interest, user: user }
  let(:json) { MultiJson.load response.body }
  let(:api_token) { user.api_token }
  let(:headers) do
    {
      'X-Token' => api_token
    }
  end

  describe '#index' do
    let(:text) { 'This is cool snippet' }
    let!(:submission) do
      create(:submission, text: text, interest: interest, user: user, tag_list: ['idea', 'todo'])
    end
    let(:version) { 'v1' }

    subject { get "/api/#{version}/interests/#{interest.id}/submissions", headers: headers }

    context 'unauthenticated user' do
      let(:api_token) { nil }
      it_behaves_like :unauthenticated_user
    end


    context 'version 1.1' do
      let(:version) { 1.1 }

      context 'authenticated user' do
        context 'personal interest' do
          context 'sumbisson without link or tags' do
            specify do
              subject
              expect(response.status).to eq(200)
              expect(json).to eq(
                [{
                  "id" => submission.id,
                  "interest_id" => interest.id,
                  "user_id" => user.id,
                  "title" => nil,
                  "text" => "This is cool snippet",
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
                }]
              )
            end
          end
        end

        context 'submission with link and hashtags' do
          let(:text) { 'This is cool snippet https://google.com #fun #idea #google' }

          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq(
              [{
                "id" => submission.id,
                "interest_id" => interest.id,
                "user_id" => user.id,
                "title" => nil,
                "text" => "This is cool snippet https://google.com #fun #idea #google",
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
              }]
            )
          end
        end
      end

      context 'shared interest' do
        let!(:interest_membership) do
          create :interest_membership, interest: interest
        end

        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq(
            [{
              "id" => submission.id,
              "interest_id" => interest.id,
              "user_id" => user.id,
              "text" => "This is cool snippet",
              "url" => share_url(submission.hashid),
              "link" => nil,
              "note" => nil,
              "image" => nil,
              "attachment" => nil,
              "owner" => {
                "name" => "Jack Daniels",
                "avatar" => nil
              },
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
            }]
          )
        end
      end
    end
  end

  describe '#create' do
    let(:version) { 'v1' }
    subject do
      post "/api/#{version}/interests/#{interest.id}/submissions", params: params, headers: headers
    end

    context 'unauthenticated user' do
      let(:params) { {} }
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'version 1.1' do
      let(:version) { 1.1 }

      context 'authenticated user' do
        context 'valid params' do
          let(:params) do
            {
              submission: {
                text: 'What a great day today #fun'
              }
            }
          end
          let(:submission) { Submission.last }
          let(:tag_id) { Tag.last.id }

          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq(
              {
                "id" => submission.id,
                "interest_id" => interest.id,
                "user_id" => user.id,
                "title" => nil,
                "text" => "What a great day today #fun",
                "url" => share_url(submission.hashid),
                "link" => nil,
                "image" => nil,
                "attachment" => nil,
                "note" => nil,
                "tags" => [
                  { "id"=> tag_id, "name"=>"fun" }
                ],
                "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
              }
            )
          end

          it 'should broadcast create notification', pending: true do
            expect(NotificationBroadcastJob).to receive(:perform_now).with(
              instance_of(Submission), instance_of(User), :create
            )
            subject
          end
        end

        context 'invalid params' do
          let(:params) do
            {
              submission: {
                text: ''
              }
            }
          end

          specify do
            subject
            expect(response.status).to eq(400)
            expect(json).to eq({
              "type" => "validation",
              "errors" => {
                "text" => ["can't be blank"]
              }
            })
          end
        end
      end
    end


  end

  describe '#update' do
    let(:submission) { create(:submission, interest: interest, user: user) }
    let(:version) { 1.1 }

    subject do
      patch "/api/#{version}/interests/#{interest.id}/submissions/#{submission.id}",
        params: params,
        headers: headers
    end

    context 'unauthenticated user' do
      let(:params) { {} }
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      context 'interest member' do
        let!(:member) { create :user }
        let!(:interest_membership) { create :interest_membership, interest: interest, user: member }
        let(:params) do
          {
            submission: {
              link_attributes: {
                title: 'Changed title'
              }
            }
          }
        end
        let(:api_token) { member.api_token }

        it_behaves_like :unauthorized_user
      end

      context 'submission owner' do
        context 'submission with link' do
          let!(:link) { create(:link, submission: submission) }
          let(:params) do
            {
              submission: {
                text: 'hello world'
              }
            }
          end

          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq(
              {
                "id" => submission.id,
                "interest_id" => interest.id,
                "user_id" => user.id,
                "title" => nil,
                "text" => "hello world",
                "url" => "http://github.com",
                "link" => {
                  "title" => "GitHub · How people build software",
                  "description" => "GitHub is where people build software.",
                  "url" => "http://github.com",
                  "domain" => "github.com",
                  "image" => "https://assets-cdn.github.com/images/modules/open_graph/github-logo.png"
                },
                "note" => nil,
                "image" => nil,
                "attachment" => nil,
                "tags" => [],
                "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
              }
            )
          end
        end

        context 'note submission' do
          let(:params) do
            {
              submission: {
                text: 'hello world #fun #idea'
              }
            }
          end
          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq(
              {
                "id" => submission.id,
                "interest_id" => interest.id,
                "user_id" => user.id,
                "title" => nil,
                "text" => "hello world #fun #idea",
                "url" => share_url(submission.hashid),
                "note" => nil,
                "link" => nil,
                "image" => nil,
                "attachment" => nil,
                "tags" => [{
                    "id" => submission.tags.first.id,
                    "name" => "fun"
                  },
                  {
                    "id" => submission.tags.last.id,
                    "name" => "idea"
                  }],
                "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
              }
            )
          end
        end


        context 'submission with image' do
          let!(:image) { create(:image, submission: submission) }
          let(:params) do
            {
              submission: {
                text: 'Lorem ipsum'
              }
            }
          end
          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq(
              {
                "id" => submission.id,
                "interest_id" => interest.id,
                "user_id" => user.id,
                "title" => nil,
                "text" => "Lorem ipsum",
                "url" => "http://500px.com/photo/123",
                "image" => {
                  "title" => "Nice photo",
                  "domain" => "500px.com",
                  "url" => "http://500px.com/photo/123"
                },
                "link" => nil,
                "note" => nil,
                "attachment" => nil,
                "tags" => [],
                "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
              }
            )
          end
        end

        context 'submission with attachment' do
          let!(:attachment) { create(:attachment, submission: submission) }
          let(:params) do
            {
              submission: {
                text: 'Lorem ipsum'
              }
            }
          end
          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq(
              {
                "id" => submission.id,
                "interest_id" => interest.id,
                "user_id" => user.id,
                "title" => nil,
                "text" => "Lorem ipsum",
                "url" => "http://example.com/1.pdf",
                "attachment" => {
                  "title" => "1.pdf",
                  "format"=>"pdf",
                  "domain" => "example.com",
                  "url" => "http://example.com/1.pdf"
                },
                "link" => nil,
                "note" => nil,
                "image" => nil,
                "tags" => [],
                "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
              }
            )
          end
        end
      end
    end
  end

  describe '#destroy' do
    let(:submission) { create(:submission, interest: interest, user: user) }
    let(:version) { 1.1 }
    subject do
      delete "/api/#{version}/interests/#{interest.id}/submissions/#{submission.id}", headers: headers
    end

    context 'unauthenticated user' do
      let(:params) { {} }
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end


    context 'authenticated user' do
      context 'interest member' do
        let!(:member) { create :user }
        let!(:interest_membership) { create :interest_membership, interest: interest, user: member }
        let(:params) do
          {
            submission: {
              link_attributes: {
                title: 'Changed title'
              }
            }
          }
        end
        let(:api_token) { member.api_token }

        it_behaves_like :unauthorized_user
      end

      context 'submission owner' do
        context 'submission with link' do
          let!(:link) { create(:link, submission: submission) }

          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq(
              {
                "id" => submission.id,
                "interest_id" => interest.id,
                "user_id" => user.id,
                "title" => nil,
                "text" => "This is cool snippet",
                "url" => "http://github.com",
                "link" => {
                  "title" => "GitHub · How people build software",
                  "url" => "http://github.com",
                  "domain" => "github.com",
                  "description" => "GitHub is where people build software.",
                  "image" => "https://assets-cdn.github.com/images/modules/open_graph/github-logo.png"
                },
                "note" => nil,
                "image" => nil,
                "attachment" => nil,
                "tags" => [],
                "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
              }
            )
          end

          it 'should destroy submission' do
            subject
            expect(interest.submissions.count).to eq(0)
          end

          it 'should destroy link' do
            subject
            expect(Link.count).to eq(0)
          end
        end

        context 'note submission' do

          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq(
              {
                "id" => submission.id,
                "interest_id" => interest.id,
                "user_id" => user.id,
                "title" => nil,
                "text" => "This is cool snippet",
                "url" => share_url(submission.hashid),
                "link" => nil,
                "note" => nil,
                "image" => nil,
                "attachment" => nil,
                "tags" => [],
                "date" => submission.created_at.strftime('%b %d, %Y %H:%M %p')
              }
            )
          end

          it 'should destroy submission' do
            subject
            expect(interest.submissions.count).to eq(0)
          end
        end
      end
    end
  end
end
