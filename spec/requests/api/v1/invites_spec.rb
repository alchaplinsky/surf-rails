require 'rails_helper'
require_relative 'shared_examples'

describe 'Invites' do
  let!(:user) { create(:user) }
  let(:json) { MultiJson.load response.body }
  let(:api_token) { user.reload.api_token }
  let(:headers) do
    {
      'X-Token' => api_token
    }
  end

  describe '#create' do
    let(:params) { { invite: { email: 'john.doe@example.com' } } }

    subject { post '/api/v1/invites', params: params, headers: headers }

    context 'unauthenticated user' do
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      context 'valid params' do
        let(:invite) { Invite.last }
        let(:mailer) { double('mailer') }

        before do
          allow(InviteMailer).to receive(:invite).and_return(mailer)
        end

        specify do
          expect(mailer).to receive(:deliver_later)
          subject
          expect(response.status).to eq(200)
          expect(json).to eq({ "email" => "john.doe@example.com"})
        end
      end

      context 'invalid params' do
        let(:params) { { invite: { email: 'john.doe.example.com' } } }

        specify do
          subject
          expect(response.status).to eq(400)
          expect(json).to eq({ "type" => "validation", "errors" => {"email"=>["Email is invalid"]} })
        end
      end
    end
  end
end
