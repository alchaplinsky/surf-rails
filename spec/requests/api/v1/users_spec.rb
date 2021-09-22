require 'rails_helper'
require_relative 'shared_examples'

describe 'Users' do
  let!(:user) { create(:user, email: 'jack.daniels@gmail.com') }

  let(:json) { MultiJson.load response.body }
  let(:api_token) { user.reload.api_token }

  let(:headers) do
    {
      'X-Token' => api_token
    }
  end
  describe '#index' do
    subject { get '/api/v1/users', headers: headers, params: params }

    context 'unauthorized user' do
      let(:params) { { query: 'some query'} }
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authorized user' do
      context 'empty query' do
        let(:params) { { query: ''} }

        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq([])
        end
      end

      context 'query present' do
        let!(:user1) do
          create(:user, first_name: 'Alex', last_name: 'Johnes', email: 'gordon@ex.cc')
        end

        context 'first name matches' do
          let(:params) { { query: 'al'} }

          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq([{
              "id" => user1.id,
              "first_name" => "Alex",
              "last_name" => "Johnes",
              "email" => "gordon@ex.cc",
              "avatar" => nil,
              "premium" => false,
              "provider_name" => "Facebook"
            }])
          end
        end

        context 'last name matches' do
          let(:params) { { query: 'jo'} }

          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq([{
              "id" => user1.id,
              "first_name" => "Alex",
              "last_name" => "Johnes",
              "email" => "gordon@ex.cc",
              "avatar" => nil,
              "premium" => false,
              "provider_name" => "Facebook"
            }])
          end
        end

        context 'email name matches' do
          let(:params) { { query: 'go'} }

          specify do
            subject
            expect(response.status).to eq(200)
            expect(json).to eq([{
              "id" => user1.id,
              "first_name" => "Alex",
              "last_name" => "Johnes",
              "email" => "gordon@ex.cc",
              "avatar" => nil,
              "premium" => false,
              "provider_name" => "Facebook"
            }])
          end
        end

      end
    end
  end
  describe '#show' do
    subject { get '/api/v1/users/me', headers: headers }

    context 'authorized user' do
      context 'user without avatar' do
        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq({
            "id" => user.id,
            "first_name" => "Jack",
            "last_name" => "Daniels",
            "email" => "jack.daniels@gmail.com",
            "avatar" => nil,
            "premium" => false,
            "provider_name" => "Facebook"
          })
        end
      end

      context 'user with avatar' do
        let!(:user) { create :user, :with_avatar, email: 'jack@gmail.com' }
        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq({
            "id" => user.id,
            "first_name" => "Jack",
            "last_name" => "Daniels",
            "email" => "jack@gmail.com",
            "avatar" => {
              "url" => user.avatar.url
            },
            "premium" => false,
            "provider_name" => "Facebook"
          })
        end
      end
    end

    context 'unauthorized user' do
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end
  end
end
