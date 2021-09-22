require 'rails_helper'

describe Link do
  context 'db columns' do
    it { is_expected.to have_db_column(:submission_id).of_type(:integer) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:url).of_type(:string) }
    it { is_expected.to have_db_column(:domain).of_type(:string) }
    it { is_expected.to have_db_column(:image).of_type(:string) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:submission) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:submission) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:domain) }
    it { is_expected.to validate_presence_of(:image) }
  end
end
