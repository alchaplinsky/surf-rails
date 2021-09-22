require 'rails_helper'
require_relative 'shared_examples'

describe 'Tags' do
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
    let!(:submission1) do
      create(:submission, interest: interest, user: user, tag_list: ['idea', 'ideal'])
    end
    let!(:submission2) do
      create(:submission, interest: interest, user: user, tag_list: ['idea', 'article'])
    end
    let!(:submission3) do
      create(:submission, interest: interest, user: user, tag_list: ['idea', 'article'])
    end
    let(:query) { '' }

    subject { get "/api/v1/tags?query=#{query}", headers: headers }

    context 'unauthenticated user' do
      let(:api_token) { nil }
      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      context 'empty query' do
        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq([
            { "name" => "idea", "count" => 3 },
            { "name" => "article", "count" => 2 },
            { "name" => "ideal", "count" => 1 }
          ])
        end
      end

      context 'present query' do
        let(:query) { 'id' }

        specify do
          subject
          expect(response.status).to eq(200)
          expect(json.map{|item| item["name"]}).to eq([
            'idea', 'ideal'
          ])
        end
      end
    end
  end
end
