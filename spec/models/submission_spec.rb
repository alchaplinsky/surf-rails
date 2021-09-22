require 'rails_helper'

describe Submission do
  context 'db columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:text).of_type(:text) }
    it { is_expected.to have_db_column(:interest_id).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:interest) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:link).dependent(:destroy) }
    it { is_expected.to have_one(:note).dependent(:destroy) }
    it { is_expected.to have_one(:image).dependent(:destroy) }
    it { is_expected.to have_one(:attachment).dependent(:destroy) }
    it { is_expected.to have_many(:taggings) }
    it { is_expected.to have_many(:tags).through(:taggings) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:interest) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:text) }
  end

  context '#tag_list' do
    let(:user) { create :user }
    let!(:interest){ create :interest, user: user }
    let(:submission) do
      build(:submission, interest: interest, user: user, tag_list: ['article', 'IdEa'])
    end

    subject { submission.save }

    before do
      subject
    end

    it 'should create submission' do
      expect(user.submissions.size).to eq(1)
    end

    it 'should create tags' do
      expect(Tag.all.pluck(:name)).to eq(['article', 'idea'])
    end

    it 'should create taggings' do
      expect(user.submissions.first.tags.pluck(:name)).to eq(['article', 'idea'])
    end
  end
end
