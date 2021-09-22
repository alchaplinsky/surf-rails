require 'rails_helper'

describe Oauth::AuthService do
  let(:params) do
    {
      user_id: user_id,
      provider: provider,
      token: token,
    }
  end
  let(:user_id) { '123456' }
  let(:provider) { 'facebook' }
  let(:token) { 'ACCESS_TOKEN' }

  let(:service) { described_class.new(params) }

  describe '#authenticate' do
    subject { service.authenticate }

    context 'invalid params' do
      context 'provider is not present' do
        let(:provider) { nil }
        specify { expect(subject).to eq false }
      end
      context 'access token is not present' do
        let(:token) { nil }
        specify { expect(subject).to eq false }
      end
      context 'user_id is not present' do
        let(:user_id) { nil }
        specify { expect(subject).to eq false }
      end
      context 'provider is not supported' do
        let(:provider) { 'twitter' }
        specify { expect(subject).to eq false }
      end
    end

    context 'valid params' do
      context 'facebook provider' do
        context 'unsuccessfull data load' do
          before do
            ExternalRequestSupport.mock_request(
              'https://graph.facebook.com/v2.11/123456?fields=name,email&access_token=ACCESS_TOKEN', 400, 'application/json; charset=UTF-8', JSON.dump({
                "error": {
                "message": "Invalid OAuth access token.",
                "type": "OAuthException",
                "code": 190,
                "fbtrace_id": "AU75I6m8YCy"
                }
              })
            )
          end

          specify do
            expect(subject).to eq false
          end
        end

        context 'successfull data load' do
          let(:instance) { double('service') }
          let(:user) { create(:user) }

          before do
            allow(instance).to receive(:find_or_create_from_oauth).and_return(user)
            allow(Oauth::FacebookService).to receive(:new).and_return(instance)
            ExternalRequestSupport.mock_request(
              'https://graph.facebook.com/v2.11/123456?fields=name,email&access_token=ACCESS_TOKEN', 200, 'application/json; charset=UTF-8', JSON.dump({
                "id": "123456",
                "name": "John Doe",
                "email": "john.doe@example.com"
              })
            )
          end

          specify do
            expect(instance).to receive(:find_or_create_from_oauth).with(
              OpenStruct.new(
                {
                  provider: 'facebook',
                  uid: '123456',
                  info: OpenStruct.new({
                    email: "john.doe@example.com",
                    name: "John Doe",
                    image: "https://graph.facebook.com/v2.11/123456/picture"
                  })
                }
              )
            )
            expect(subject).to eq(user)
          end
        end
      end

      context 'google provider' do
        let(:provider) { 'google_oauth2' }

        context 'unsuccessfull data load' do
          before do
            ExternalRequestSupport.mock_request(
              'https://www.googleapis.com/oauth2/v1/userinfo?access_token=ACCESS_TOKEN', 401, 'application/json; charset=UTF-8', JSON.dump({
                "error": {
                  "errors": [
                    {
                      "domain": "global",
                      "reason": "authError",
                      "message": "Invalid Credentials",
                      "locationType": "header",
                      "location": "Authorization"
                    }
                  ],
                  "code": 401,
                  "message": "Invalid Credentials"
                }
              })
            )
          end

          specify do
            expect(subject).to eq false
          end
        end

        context 'successfull data load' do
          let(:instance) { double('service') }
          let(:user) { create(:user) }

          before do
            allow(instance).to receive(:find_or_create_from_oauth).and_return(user)
            allow(Oauth::GoogleService).to receive(:new).and_return(instance)
            ExternalRequestSupport.mock_request(
              'https://www.googleapis.com/oauth2/v1/userinfo?access_token=ACCESS_TOKEN', 200, 'application/json; charset=UTF-8', JSON.dump({
                "id": "123456",
                "given_name": "John",
                "family_name": "Doe",
                "email": "john.doe@example.com",
                "picture": "https://placehold.it/200x200"
              })
            )
          end

          specify do
            expect(instance).to receive(:find_or_create_from_oauth).with(
              OpenStruct.new(
                {
                  provider: 'google_oauth2',
                  uid: '123456',
                  info: OpenStruct.new({
                    email: "john.doe@example.com",
                    first_name: "John",
                    last_name: "Doe",
                    image: "https://placehold.it/200x200"
                  })
                }
              )
            )
            expect(subject).to eq(user)
          end
        end
      end
    end
  end
end
