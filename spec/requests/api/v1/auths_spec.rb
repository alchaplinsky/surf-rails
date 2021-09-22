require 'rails_helper'
require_relative 'shared_examples'

describe 'Auth' do
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

  describe '#show' do
    subject { get "/api/1.1/auth?user_id=#{user_id}&provider=#{provider}&token=#{token}" }

    context 'invalid params' do
      context 'user id is not present' do
        let(:user_id) { nil }

        specify do
          subject
          expect(response.status).to eq(401)
          expect(response.body).to eq('{"type":"authorization_error","message":"You are not authorized to perform this action"}')
        end
      end
      context 'provider is not present' do
        let(:provider) { nil }

        specify do
          subject
          expect(response.status).to eq(401)
          expect(response.body).to eq('{"type":"authorization_error","message":"You are not authorized to perform this action"}')
        end
      end
      context 'access token is not present' do
        let(:token) { nil }

        specify do
          subject
          expect(response.status).to eq(401)
          expect(response.body).to eq('{"type":"authorization_error","message":"You are not authorized to perform this action"}')
        end
      end
      context 'provider is not supported' do
        let(:provider) { 'twitter' }

        specify do
          subject
          expect(response.status).to eq(401)
          expect(response.body).to eq('{"type":"authorization_error","message":"You are not authorized to perform this action"}')
        end
      end
    end

    context 'valid params' do
      context 'facebook provider' do
        context 'unsuccessfull data load' do
          before do
            ExternalRequestSupport.mock_request(
              'https://graph.facebook.com/v2.11/123456?access_token=ACCESS_TOKEN&fields=name,email', 400, 'application/json; charset=UTF-8', JSON.dump({
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
            subject
            expect(response.status).to eq(401)
            expect(response.body).to eq('{"type":"authorization_error","message":"You are not authorized to perform this action"}')
          end
        end

        context 'successfull data load' do
          before do
            ExternalRequestSupport.mock_remote_image('https://graph.facebook.com/v2.11/123456/picture')
            ExternalRequestSupport.mock_request(
              'https://graph.facebook.com/v2.11/123456?fields=name,email&access_token=ACCESS_TOKEN', 200, 'application/json; charset=UTF-8', JSON.dump({
                "id": "123456",
                "name": "John Doe",
                "email": "john.doe@example.com"
              })
            )
          end

          context 'User exists' do
            context 'with same email but different provider' do
              let!(:user) { create(:user, uid: '654321', provider: 'google_oauth2', email: 'john.doe@example.com' ) }

              specify do
                subject
                expect(response.status).to eq(400)
                expect(response.body).to eq("{\"email\":[\"User with this email already exists\"]}")
              end
            end

            context 'different email' do
              let!(:user) { create(:user, uid: '123456', provider: 'facebook' ) }

              specify do
                subject
                expect(response.status).to eq(200)
              end

              it 'should not create new user' do
                subject
                expect(User.count).to eq(1)
              end

              it 'should return existing user api_token' do
                subject
                expect(JSON.parse(response.body)).to eq({ "api_token" => user.api_token})
              end
            end
          end

          context 'User does not exist' do
            let(:user) { User.last }

            specify do
              subject
              expect(response.status).to eq(200)
            end

            it 'should create new user' do
              subject
              expect(User.count).to eq(1)
              expect(user.uid).to eq('123456')
              expect(user.provider).to eq('facebook')
              expect(user.first_name).to eq('John')
              expect(user.last_name).to eq('Doe')
              expect(user.email).to eq('john.doe@example.com')
            end

            it 'should return existing user api_token' do
              subject
              expect(JSON.parse(response.body)).to eq({ "api_token" => user.api_token})
            end
          end
        end
      end

      context 'google provider' do
        let(:provider) { 'google_oauth2' }

        before do
          ExternalRequestSupport.mock_remote_image('https://placehold.it/200x200')
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

        context 'User exists' do
          context 'with same email but different provider' do
            let!(:user) { create(:user, uid: '654321', provider: 'facebook', email: 'john.doe@example.com' ) }

            specify do
              subject
              expect(response.status).to eq(400)
              expect(response.body).to eq("{\"email\":[\"User with this email already exists\"]}")
            end
          end
          context 'different email' do
            let!(:user) { create(:user, uid: '123456', provider: 'google_oauth2') }

            specify do
              subject
              expect(response.status).to eq(200)
            end

            it 'should not create new user' do
              subject
              expect(User.count).to eq(1)
            end

            it 'should return existing user api_token' do
              subject
              expect(JSON.parse(response.body)).to eq({ "api_token" => user.api_token})
            end
          end
        end

        context 'User does not exist' do
          let(:user) { User.last }

          specify do
            subject
            expect(response.status).to eq(200)
          end

          it 'should create new user' do
            subject
            expect(User.count).to eq(1)
            expect(user.uid).to eq('123456')
            expect(user.provider).to eq('google_oauth2')
            expect(user.first_name).to eq('John')
            expect(user.last_name).to eq('Doe')
            expect(user.email).to eq('john.doe@example.com')
          end

          it 'should return existing user api_token' do
            subject
            expect(JSON.parse(response.body)).to eq({ "api_token" => user.api_token})
          end
        end
      end
    end
  end
end
