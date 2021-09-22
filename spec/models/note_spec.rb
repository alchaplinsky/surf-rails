require 'rails_helper'

describe Note do
  context 'db columns' do
    it { is_expected.to have_db_column(:submission_id).of_type(:integer) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:text).of_type(:text) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:submission) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:submission) }
    it { is_expected.to validate_presence_of(:text) }
  end
end
