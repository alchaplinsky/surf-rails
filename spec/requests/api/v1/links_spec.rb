require 'rails_helper'
require_relative 'shared_examples'

describe 'Links parsing' do
  let(:user) { create :user }
  let(:json) { MultiJson.load response.body }
  let(:api_token) { user.api_token }
  let(:headers) do
    {
      'X-Token' => api_token
    }
  end
  let(:url) { 'https://medium.com/@thegreatkillfile/on-north-korea-ebbbafed762e' }
  let(:page) { create :page }
  subject do
    get "/api/v1/links/parse?url=#{url}", headers: headers
  end

  context 'unauthenticated user' do
    let(:api_token) { nil }

    it_behaves_like :unauthenticated_user
  end

  context 'authenticated user' do
    before do
      allow_any_instance_of(MetaInspector).to receive(:new)
        .with(url, allow_non_html_content: true).and_return(page)
    end

    specify do
      subject
      expect(response.status).to eq(200)
      expect(json).to eq(
        {
          "title" => "On North Korea – Chris Thomas – Medium",
          "description" => "Let’s be clear — North Korea does not want war with the United States and the United States has …",
          "image" => "https://cdn-images-1.medium.com/max/1200/0*SrD-iw1XF2p45ZO7.jpg",
          "domain" => "medium.com",
          "url" => "https://medium.com/@thegreatkillfile/on-north-korea-ebbbafed762e"
        }
      )
    end
  end
end
