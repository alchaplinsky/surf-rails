require 'rails_helper'

describe InterestMembership do
  context 'db columns' do
    it { is_expected.to have_db_column(:interest_id).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:role).of_type(:string) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:interest) }
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:interest) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:role) }

    context 'uniqueness' do
      let(:interest) { create :interest, user: create(:user) }
      subject { interest.interest_memberships.first }
      
      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:interest_id) }
    end
  end

end
