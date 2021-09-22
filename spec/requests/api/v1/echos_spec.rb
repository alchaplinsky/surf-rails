require 'rails_helper'
require_relative 'shared_examples'

describe 'Echos' do
  let!(:user) { create(:user) }
  let(:json) { MultiJson.load response.body }
  let(:api_token) { user.reload.api_token }
  let(:headers) do
    {
      'X-Token' => api_token
    }
  end

  describe '#show' do
    subject { get '/api/v1/echo', headers: headers }

    context 'authorized user' do
      specify do
        subject
        expect(response.status).to eq(204)
        expect(response.body).to eq('')
      end
    end

    context 'unauthorized user' do
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end
  end
end
