require 'rails_helper'

describe User do
  context 'db columns' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:avatar).of_type(:string) }
    it { is_expected.to have_db_column(:api_token).of_type(:string) }
    it { is_expected.to have_db_column(:provider).of_type(:string) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:app_connected_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:platform).of_type(:string) }
    it { is_expected.to have_db_column(:premium).of_type(:boolean) }
  end

  context 'associations' do
    it { is_expected.to have_many(:tags).dependent(:destroy) }
    it { is_expected.to have_many(:invites).dependent(:destroy) }
    it { is_expected.to have_many(:interest_memberships).dependent(:destroy) }
    it { is_expected.to have_many(:submissions).dependent(:destroy) }
    it { is_expected.to have_many(:invites).dependent(:destroy) }
    it { is_expected.to have_many(:upgrades).dependent(:destroy) }
    it { is_expected.to have_many(:own_interests).through(:interest_memberships) }
    it { is_expected.to have_many(:interests).through(:interest_memberships) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:api_token) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_presence_of(:provider) }
  end
end
