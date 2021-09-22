require 'rails_helper'

describe Upgrade do
  context 'db columns' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:order_id).of_type(:string) }
    it { is_expected.to have_db_column(:payer_id).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:phone).of_type(:string) }
    it { is_expected.to have_db_column(:country).of_type(:string) }
    it { is_expected.to have_db_column(:status).of_type(:string) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:order_id) }
    it { is_expected.to validate_presence_of(:payer_id) }
  end
end
