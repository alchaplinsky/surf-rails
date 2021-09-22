require 'rails_helper'

describe Tagging do
  context 'db columns' do
    it { is_expected.to have_db_column(:tag_id).of_type(:integer) }
    it { is_expected.to have_db_column(:submission_id).of_type(:integer) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:tag) }
    it { is_expected.to belong_to(:submission) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:tag) }
    it { is_expected.to validate_presence_of(:submission) }
  end
end
