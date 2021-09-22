require 'rails_helper'
require_relative 'shared_examples'

describe 'Interests' do
  let!(:user) { create(:user) }
  let(:json) { MultiJson.load response.body }
  let(:api_token) { user.reload.api_token }
  let(:headers) do
    {
      'X-Token' => api_token
    }
  end

  describe '#index' do
    let!(:interest) { create :interest, user: user }

    subject { get '/api/v1/interests', headers: headers }

    context 'unauthenticated user' do
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq(
          [{
            "id" => interest.id,
            "user_id" => interest.owner.id,
            "name" => "Travel",
            "posts_count" => 0,
            "shared" => false,
            "membership" => {
              "id" => user.interest_memberships.first.id,
              "role" => "owner"
            },
            "tags" => []
          }]
        )
      end
    end
  end

  describe '#show' do
    let!(:interest) { create :interest, user: user }
    let!(:submission1) { create :submission, interest: interest, user: user, tag_list: ['article', 'fun']}
    let!(:submission2) { create :submission, interest: interest, user: user, tag_list: ['science', 'article']}
    let!(:membership) do
      create :interest_membership,
        user: create(:user, first_name: 'Frank', last_name: 'Jhones'),
        interest: interest
    end

    subject { get "/api/v1/interests/#{interest.id}", headers: headers }

    context 'unauthenticated user' do
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq(
          {
            "id" => interest.id,
            "user_id" => interest.owner.id,
            "name" => "Travel",
            "posts_count" => 2,
            "shared" => true,
            "membership" => {
              "id" => user.interest_memberships.first.id,
              "role" => "owner"
            },
            "tags" => ["article", "fun", "science"]
          }
        )
      end
    end
  end

  describe '#create' do
    subject { post '/api/v1/interests', params: params, headers: headers }

    context 'unauthenticated user' do
      let(:params) { {} }
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      context 'valid params' do
        let(:params) do
          {
            interest: {
              name: 'Bloging'
            }
          }
        end
        let(:interest) { user.own_interests.last }

        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq(
            {
              "id" => interest.id,
              "user_id" => user.id,
              "name" => "Bloging",
              "posts_count" => 0,
              "shared" => false,
              "membership" => {
                "id" => user.interest_memberships.first.id,
                "role" => "owner"
              },
              "tags" => []
            }
          )
        end
      end
      context 'invalid params' do
        let(:params) do
          {
            interest: {
              name: ''
            }
          }
        end

        specify do
          subject
          expect(response.status).to eq(400)
          expect(json).to eq({
            "type" => "validation",
            "errors" => {
              "name" => ["can't be blank"]
            }
          })
        end
      end

      context 'interest with given name already exists' do
        let!(:interest) { create :interest, user: user, name: 'music' }
        let(:params) do
          {
            interest: {
              name: 'music'
            }
          }
        end

        specify do
          subject
          expect(response.status).to eq(400)
          expect(json).to eq({
            "type" => "validation",
            "errors" => {
              "name" => ["This interest already exists"]
            }
          })
        end
      end
    end
  end

  describe '#update' do
    let!(:interest) { create :interest, user: user, name: 'random' }

    subject { patch "/api/v1/interests/#{interest.id}", params: params, headers: headers }

    context 'unauthenticated user' do
      let(:params) { {} }
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      context 'valid params' do
        let(:params) do
          {
            interest: {
              name: 'blogging'
            }
          }
        end

        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq(
            {
              "id" => interest.id,
              "user_id" => user.id,
              "name" => "blogging",
              "posts_count" => 0,
              "shared" => false,
              "membership" => {
                "id" => user.interest_memberships.first.id,
                "role" => "owner"
              },
              "tags" => []
            }
          )
        end
        it 'should change interest name' do
          subject
          expect(interest.reload.name).to eq('blogging')
        end
      end

      context 'invalid params' do
        let(:params) do
          {
            interest: {
              name: ''
            }
          }
        end

        specify do
          subject
          expect(response.status).to eq(400)
          expect(json).to eq({
            "type" => "validation",
            "errors" => {
              "name" => ["can't be blank"]
            }
          })
        end

        it 'should not change interest name' do
          subject
          expect(interest.reload.name).to eq('random')
        end
      end

      context 'interest with given name already exists' do
        let!(:interest1) { create :interest, user: user, name: 'music' }
        let(:params) do
          {
            interest: {
              name: 'music'
            }
          }
        end

        specify do
          subject
          expect(response.status).to eq(400)
          expect(json).to eq({
            "type" => "validation",
            "errors" => {
              "name" => ["This interest already exists"]
            }
          })
        end
      end
    end
  end

  describe '#destroy' do
    let!(:interest) { create :interest, user: user }

    subject { delete "/api/v1/interests/#{interest.id}", headers: headers }

    context 'unauthenticated user' do
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq(
          {
            "id" => interest.id,
            "user_id" => user.id,
            "name" => "Travel",
            "posts_count" => 0,
            "shared" => false,
            "membership" => nil
          }
        )
      end
      it 'should delete interest' do
        subject
        expect(user.own_interests.count).to eq(0)
      end
    end
  end
end
