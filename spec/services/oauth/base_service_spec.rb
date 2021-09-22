require 'rails_helper'

describe Oauth::BaseService do
  let(:service) { described_class.new }

  before do
    ExternalRequestSupport.mock_remote_image('https://placehold.it/200x200')
  end

  describe '#find_or_create_from_oauth' do
    let(:invite_token) { nil }
    let(:auth) do
      OmniAuth::AuthHash.new({
        'provider' =>'facebook',
        'uid' => '123545',
        'info' => {
          'name' => 'John Doe',
          'email' => 'john.doe@example.com',
          'first_name' => 'John',
          'last_name' => 'Doe',
          'image' => "https://placehold.it/200x200"
        }
      })
    end

    subject { service.find_or_create_from_oauth(auth, invite_token) }

    context 'user exists' do
      let!(:user) { create :user, provider: 'facebook', uid: '123545' }

      it 'should return found user' do
        expect(subject).to eq user
      end
    end

    context 'user does not exist' do
      let(:user) { User.last }

      it 'should create user from auth params' do
        expect(subject).to eq(user)
        expect(user.first_name).to eq 'John'
        expect(user.last_name).to eq 'Doe'
        expect(user.email).to eq 'john.doe@example.com'
        expect(user.provider).to eq 'facebook'
        expect(user.uid).to eq '123545'
      end

      it 'should create default interest' do
        subject
        expect(user.own_interests.size).to eq 1
        expect(user.own_interests.first.name).to eq 'getting_started'
      end

      context 'user with invite' do
        let!(:invite) { create :invite, status: 'pending' }
        let(:invite_token) { invite.token }

        it 'should accept invite' do
          subject
          expect(invite.reload.status).to eq 'accepted'
        end
      end
    end
  end

  describe '#create_from_params' do
    let(:invite_token) { nil }
    let(:params) do
      {
        provider: 'facebook',
        uid: '123456',
        first_name: 'Mike',
        last_name: 'Spike',
        email: 'mike.spike@example.com',
        remote_avatar_url: '',
        password: '7654321',
        api_token: 'API_TOKEN'
      }
    end
    let(:user) { User.last }

    subject { service.create_from_params(params, invite_token) }

    it 'should create user from params' do
      expect(subject).to eq(user)
      expect(user.first_name).to eq 'Mike'
      expect(user.last_name).to eq 'Spike'
      expect(user.email).to eq 'mike.spike@example.com'
      expect(user.provider).to eq 'facebook'
      expect(user.uid).to eq '123456'
    end

    context 'user with invite' do
      let!(:invite) { create :invite, status: 'pending' }
      let(:invite_token) { invite.token }

      it 'should accept invite' do
        subject
        expect(invite.reload.status).to eq 'accepted'
      end
    end
  end
end
