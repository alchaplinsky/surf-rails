require 'rails_helper'

describe HashtagsService do
  let(:text) { '#article #GoProHero How to create cool videos with GoPro #tips' }

  describe '#parse_tags' do
    subject { described_class.parse_tags(text) }

    it { is_expected.to eq(['article', 'GoProHero', 'tips']) }
  end

  describe '#without_tags' do
    subject { described_class.without_tags(text) }

    it { is_expected.to eq('How to create cool videos with GoPro') }
  end
end
