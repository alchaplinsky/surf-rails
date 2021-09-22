require 'rails_helper'
require_relative 'shared_examples'

describe 'Interest Membeships' do
  let!(:owner) { create(:user) }
  let!(:member) { create :user, first_name: 'Frank', last_name: 'Johnson' }
  let!(:interest) { create :interest, user: owner }
  let!(:another_interest){ create :interest, user: create(:user) }
  let(:json) { MultiJson.load response.body }
  let(:api_token) { owner.reload.api_token }
  let(:headers) do
    {
      'X-Token' => api_token
    }
  end

  describe '#index' do
    let!(:membership) { create :interest_membership, user: member, interest: interest }

    subject do
      get "/api/v1/interests/#{interest.id}/interest_memberships", headers: headers
    end

    context 'unauthenticated user' do
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq([
          {
            "id" => owner.interest_memberships.first.id,
            "interest_id" => interest.id,
            "role" => "owner",
            "user" => {
              "id" => owner.id,
              "first_name" => "Jack",
              "last_name" => "Daniels",
              "email" => owner.email,
              "avatar" => nil,
              "premium" => false,
              "provider_name" => "Facebook"
            }
          },
          {
            "id" => membership.id,
            "interest_id" => interest.id,
            "role" => "member",
            "user" => {
              "id" => member.id,
              "first_name" => "Frank",
              "last_name" => "Johnson",
              "email" => member.email,
              "avatar" => nil,
              "premium" => false,
              "provider_name" => "Facebook"
            }
          }
        ])
      end
    end
  end

  describe '#create' do
    subject do
      post '/api/v1/interest_memberships', params: params, headers: headers
    end

    context 'unauthenticated user' do
      let(:params) { {} }
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      let(:params) do
        {
          user_id: member.id,
          interest_id: interest.id
        }
      end
      let(:interest_membership) { InterestMembership.last }

      context 'valid params' do
        specify do
          subject
          expect(response.status).to eq(200)
          expect(json).to eq(
            {
              "id" => interest_membership.id,
              "interest_id" => interest.id,
              "role" => "member",
              "user" => {
                "id" => member.id,
                "first_name" => "Frank",
                "last_name" => "Johnson",
                "email" => member.email,
                "avatar" => nil,
                "premium" => false,
                "provider_name" => "Facebook"
              }
            }
          )
        end

        it 'should create membership for a user' do
          subject
          expect(member.interests).to include(interest)
        end

        it 'should broadcast create notification', pending: true do
          expect(NotificationBroadcastJob).to receive(:perform_now).with(
            instance_of(InterestMembership), instance_of(User), :create
          )
          subject
        end
      end

      context 'Non existing user' do
        let(:params) do
          {
            user_id: member.id + 10,
            interest_id: interest.id
          }
        end

        specify do
          expect{subject}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'User is not owner of interest' do
        let(:params) do
          {
            user_id: member.id,
            interest_id: another_interest.id
          }
        end

        specify do
          expect{subject}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe '#destroy' do
    let!(:membership) { create :interest_membership, user: member, interest: interest }
    let(:membership_id) { membership.id }

    subject do
      delete "/api/v1/interest_memberships/#{membership_id}", headers: headers
    end

    shared_examples_for :delete_interest_memberhip do
      specify do
        subject
        expect(response.status).to eq(200)
        expect(json).to eq(
          {
            "id" => membership.id,
            "interest_id" => interest.reload.id,
            "role" => "member",
            "user" => {
              "id" => member.id,
              "first_name" => "Frank",
              "last_name" => "Johnson",
              "email" => member.email,
              "avatar" => nil,
              "premium" => false,
              "provider_name" => "Facebook"
            }
          }
        )
      end

      it 'should destroy membership' do
        subject
        expect(member.interest_memberships.count).to eq(0)
      end

      it 'should broadcast destroy notification', pending: true do
        expect(NotificationBroadcastJob).to receive(:perform_now).with(
          instance_of(InterestMembership), instance_of(User), :destroy
        )
        subject
      end
    end

    context 'unauthenticated user' do
      let(:api_token) { nil }

      it_behaves_like :unauthenticated_user
    end

    context 'authenticated user' do
      context 'interest owner' do
        context 'owned intereset membership' do
          it_behaves_like :delete_interest_memberhip
        end

        context 'not owned interest membership' do
          let(:membership_id) { another_interest.interest_memberships.first.id }

          specify do
            expect{subject}.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      context 'interest member' do
        let(:api_token) { member.api_token }

        it_behaves_like :delete_interest_memberhip
      end
    end
  end
end
