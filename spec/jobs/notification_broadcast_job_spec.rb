require 'rails_helper'

describe NotificationBroadcastJob, type: :job do
  let!(:owner) { create(:user) }
  let!(:member) { create :user, first_name: 'Frank', last_name: 'Johnson' }
  let!(:interest) { create :interest, user: owner }
  let!(:membership) { create :interest_membership, user: member, interest: interest }
  let(:object) { membership }
  let(:actor) { owner }

  subject { described_class.perform_now(object, actor, action) }

  describe '.perform' do
    before do
      instance = double('service')
      allow(instance).to receive(:broadcast)
      allow(NotificationService).to receive(:new).and_return(instance)
    end

    context 'interest membership' do
      context 'create action' do
        let(:action) { :create }

        it 'should broadcast create notification to member' do
          expect(NotificationService).to receive(:new).with(membership, owner, :create)
          subject
        end
      end

      context 'destroy action' do
        let(:action) { :destroy }

        context 'interest owner' do
          it 'should broadcast destroy notification to member' do
            expect(NotificationService).to receive(:new).with(membership, owner, :destroy)
            subject
          end
        end

        context 'interest member' do
          let(:actor) { member }

          it 'should broadcast destroy notification to owner' do
            expect(NotificationService).to receive(:new).with(membership, member, :destroy)
            subject
          end
        end
      end
    end

    context 'submission' do
      let(:submission) { create :submission, interest: interest, user: owner }
      let(:object){ submission }
      let(:action) { :create }

      it 'should broadcast destroy notification to owner' do
        expect(NotificationService).to receive(:new).with(submission, owner, :create)
        subject
      end
    end
  end
end
