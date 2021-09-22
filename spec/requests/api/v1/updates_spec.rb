require 'rails_helper'

describe 'Updates' do
  let!(:user) { create(:user) }
  let(:json) { MultiJson.load response.body }
  let(:api_token) { user.reload.api_token }
  let(:os) { 'mac' }
  let(:platform) { 'x64' }
  let(:version) { '0.0.9' }
  let(:headers) do
    {
      'X-Token' => api_token
    }
  end

  describe '#show' do
    subject { get "/api/v1/update/#{os}/#{platform}/#{version}", headers: headers }

    context 'authorized user' do
      context 'update available' do
        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq({
            "url" => "https:/surfapp.io/download/mac/Surf-0.1.0.zip"
            })
        end
      end

      context 'update unavailable' do
        context 'no new version' do
          let(:version) { '0.1.0' }

          specify do
            subject
            expect(response.status).to eq(204)
            expect(response.body).to eq('')
          end
        end

        context 'unsupported operating system' do
          let(:os) { 'linux' }

          specify do
            subject
            expect(response.status).to eq(204)
            expect(response.body).to eq('')
          end
        end

        context 'unsupported architecture' do
          let(:platform) { 'ia24' }

          specify do
            subject
            expect(response.status).to eq(204)
            expect(response.body).to eq('')
          end
        end
      end
    end

    context 'unauthorized user' do
      let(:api_token) { nil }

      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq({
          "url" => "https:/surfapp.io/download/mac/Surf-0.1.0.zip"
          })
      end
    end
  end
end
