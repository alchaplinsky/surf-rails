require 'rails_helper'

describe 'API 1.2: Submissions#index search query' do
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
  let!(:submission1) do
    create :submission,
      text: '10 books to read in a year',
      interest: interest,
      user: user,
      tag_list: ['books', 'todo']
  end

  let!(:submission2) do
    create :submission,
      text: '5 Fastest cars in the world',
      interest: interest,
      user: user,
      tag_list: ['fun', 'cars']
  end
  let!(:params) do
    { query: query }
  end

  subject do
    get "/api/#{version}/interests/#{interest.id}/submissions", params: params, headers: headers
  end

  context 'text query' do
    let(:query) { 'book' }

    specify do
      subject
      expect(response.status).to eq(200)
      expect(json['results'].size).to eq 1
      expect(json['results'][0]['text']).to eq '10 books to read in a year'
      expect(json['meta']).to eq({
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
      })
    end
  end

  context 'query by tag' do
    let(:query) { '#cars' }

    specify do
      subject
      expect(response.status).to eq(200)
      expect(json['results'].size).to eq 1
      expect(json['results'][0]['text']).to eq '5 Fastest cars in the world'
      expect(json['meta']).to eq({
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
      })
    end
  end

  context 'query by text and tag' do
    context 'match exists' do
      let(:query) { '#cars in the world' }

      specify do
        subject
        expect(response.status).to eq(200)
        expect(json['results'].size).to eq 1
        expect(json['results'][0]['text']).to eq '5 Fastest cars in the world'
        expect(json['meta']).to eq({
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
        })
      end
    end

    context 'no matching results' do
      let(:query) { 'books to read #cars' }
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json['results'].size).to eq 0
      end
    end
  end
end
