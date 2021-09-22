require 'rails_helper'

describe DesktopUpdateService do
  let(:os) { 'mac' }
  let(:arch) { 'x64' }
  let(:version) { '0.0.9' }
  let(:service) { described_class.new(os, arch) }

  describe '#update_available?' do
    subject { service.update_available?(version) }

    context 'mac os' do
      context 'new version available' do
        it { is_expected.to be true }
      end

      context 'no new version available' do
        let(:version) { '0.1.0' }

        it { is_expected.to be false }
      end
    end

    context 'windows' do
      let(:os) { 'windows' }

      context 'new version available' do
        it { is_expected.to be true }
      end

      context 'no new version available' do
        let(:version) { '0.1.0' }

        it { is_expected.to be false }
      end
    end

    context 'linux' do
      let(:os) { 'linux' }

      context 'new version available' do
        it { is_expected.to be false }
      end

      context 'no new version available' do
        let(:version) { '0.1.0' }

        it { is_expected.to be false }
      end
    end
  end

  describe '#update_url' do
    subject { service.update_url }

    context 'mac os' do
      specify do
        expect(subject).to eq 'https:/surfapp.io/download/mac/Surf-0.1.0.zip'
      end
    end

    context 'windows' do
      let(:os) { 'windows' }

      specify do
        expect(subject).to eq 'https:/surfapp.io/download/windows/Surf-0.1.0.zip'
      end
    end

    context 'linux' do
      let(:os) { 'linux' }

      specify do
        expect{subject}.to raise_error('Unsupported platform')
      end
    end
  end
end
