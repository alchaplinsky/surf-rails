require 'rails_helper'

describe Interest do
  context 'db columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:users).through(:interest_memberships) }
    it { is_expected.to have_many(:submissions).dependent(:destroy) }
    it { is_expected.to have_many(:interest_memberships).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value('hello_world').for(:name) }
    it { is_expected.to allow_value('hello-world').for(:name) }
    it { is_expected.to allow_value('hello world').for(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
    it { is_expected.to validate_length_of(:name).is_at_most(24) }

    context 'plan limitations' do
      let(:user) { create :user, premium: premium }
      10.times do |i|
        let!(:"interest_#{i}") { create :interest, name: "Interest #{i}", user: user }
      end

      subject do
        create :interest, user: user
      end

      context 'free user' do
        let(:premium) { false }

        specify do
          expect{subject}.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'premium user' do
        let(:premium) { true }

        it { is_expected.to be_valid }
      end
    end
  end
end
