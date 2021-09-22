require 'rails_helper'

describe Invite do
  context 'db columns' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:status).of_type(:string) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    subject { create(:invite) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_inclusion_of(:status).in_array(%w(pending accepted declined)) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:status) }

    context 'email validation' do
      it { is_expected.to allow_value('user@example.com').for(:email) }
      it { is_expected.to_not allow_value('userexample.com').for(:email) }
      it { is_expected.to_not allow_value('user@example').for(:email) }
    end

    context 'user existence validation' do
      subject { create :invite, email: 'john.doe@example.com' }

      context 'user with same email exist' do
        let!(:user) { create :user, email: 'john.doe@example.com' }

        specify do
          expect {subject}.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email This user is already on Surf')
        end
      end

      context 'user does not exist' do
        it { is_expected.to be_valid }
      end
    end
  end
end
