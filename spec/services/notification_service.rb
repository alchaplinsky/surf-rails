require 'rails_helper'

describe NotificationService do
  let!(:owner) { create :user, first_name: 'Jack', last_name: 'Jones' }
  let!(:member) { create :user, first_name: 'Frank', last_name: 'Bean' }
  let!(:interest) { create :interest, user: owner  }
  let(:service) { described_class.new(object, actor, action) }

  describe '#broadcast' do
    subject { service.broadcast }

    context 'inerest membership' do
      let(:object) { create :interest_membership, interest: interest, user: member }
      let(:actor) { owner }

      context 'interest sharing' do
        let(:action) { :create }

        it 'should broadcast share notification to member' do
          expect(ActionCable.server).to receive(:broadcast).with(
            "notifications_#{member.id}_channel", {
              data: {
                title: 'Jack Jones',
                body: 'Has shared interest &Travel with you'
              }
            }
          )
          subject
        end
      end

      context 'interest unsharing' do
        let(:action) { :destroy }

        it 'should broadcast unshare notification to member' do
          expect(ActionCable.server).to receive(:broadcast).with(
            "notifications_#{member.id}_channel", {
              data: {
                title: 'Jack Jones',
                body: 'Has unshared interest &Travel with you'
              }
            }
          )
          subject
        end
      end

      context 'interest leaving' do
        let(:action) { :destroy }
        let(:actor) { member }

        it 'should broadcast leave notification to owner' do
          expect(ActionCable.server).to receive(:broadcast).with(
            "notifications_#{owner.id}_channel", {
              data: {
                title: 'Frank Bean',
                body: 'Has left interest &Travel'
              }
            }
          )
          subject
        end
      end
    end

    context 'submission' do
      let!(:membership) { create :interest_membership, interest: interest, user: member }
      let(:action) { :create }

      context 'owner is notified' do
        let(:object) { create :submission, interest: interest, user: member }
        let(:actor) { member }

        it 'should broadcast submission creation notification to owner' do
          expect(ActionCable.server).to receive(:broadcast).with(
            "notifications_#{owner.id}_channel", {
              data: {
                title: 'Frank Bean',
                body: 'Has added a post to &Travel'
              }
            }
          )
          subject
        end
      end

      context 'member is notified' do
        let(:object) { create :submission, interest: interest, user: owner }
        let(:actor) { owner }

        it 'should broadcast submission creation notification to member' do
          expect(ActionCable.server).to receive(:broadcast).with(
            "notifications_#{member.id}_channel", {
              data: {
                title: 'Jack Jones',
                body: 'Has added a post to &Travel'
              }
            }
          )
          subject
        end
      end
    end
  end
end
