require 'rails_helper'

describe Tag do
  context 'db columns' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:taggings) }
    it { is_expected.to have_many(:submissions).through(:taggings) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
  end
end
