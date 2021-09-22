require 'rails_helper'

describe Submission::UpdatingService do
  let(:user) { create :user }
  let(:interest) { create :interest, user: user}
  let(:submission) do
    create :submission,
      user: user,
      interest: interest,
      text: '#article #GoProHero How to create cool videos with GoPro'
  end
  let!(:tag) { create :tag, name: 'article', submissions: [submission] }
  let!(:tag) { create :tag, name: 'goprohero', submissions: [submission] }

  let(:service) { described_class.new(submission, params, api_version) }
  let(:tag_names) { Tag.all.map(&:name) }

  describe '#update' do
    subject { service.update }

    context 'api version 1.0' do
      let(:api_version) { 1.0 }
      let(:params) do
        {
          note_attributes: {
            text: 'How to create great videos with GoPro'
          },
          tag_list: '#blog #goPro #article'
        }
      end

      it 'should update submission note attributes' do
        subject
        expect(submission.text).to eq('How to create great videos with GoPro')
      end

      it 'should update taggings' do
        subject
        expect(submission.tags.map(&:name)).to eq(['blog', 'gopro', 'article'])
      end

      it 'should not delete previously created tags' do
        subject
        expect(tag_names).to contain_exactly('article', 'goprohero', 'blog', 'gopro')
      end
    end

    context 'api version 1.1' do
      let(:api_version) { 1.1 }
      let(:params) do
        {
          text: submission_text
        }
      end

      context 'text with hashtags' do
        let(:submission_text) { 'How to create great #videos with #GoPro' }
        it 'should clear empty paragraph tags' do
          subject
          expect(submission.text).to eq('How to create great #videos with #GoPro')
        end

        it 'should create new hashtags' do
          subject
          expect(submission.tags.map(&:name)).to eq(['videos', 'gopro'])
        end
      end

      context 'empty paragraph tags' do
        let(:submission_text) { "<p><br></p>" }
        it 'should clear empty paragraph tags' do
          subject
          expect(submission.text).to eq('')
        end
      end

      context 'text with empty paragraph tags in the beginning' do
        let(:submission_text) {
          "<p><br></p>
          How to create great videos with GoPro"
        }

        it 'should clear empty paragraph tags' do
          subject
          expect(submission.text).to eq('How to create great videos with GoPro')
        end
      end

      context 'text with empty paragraph tags in the middle' do
        let(:submission_text) {
          'How to create great videos with GoPro<p><br></p>Learn More'
        }

        it 'should clear empty paragraph tags' do
          subject
          expect(submission.text).to eq(
            'How to create great videos with GoPro<p><br></p>Learn More'
          )
        end
      end
    end
  end
end
