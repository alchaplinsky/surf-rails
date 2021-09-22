require 'rails_helper'

describe Submission::CreationService do
  let(:user) { create :user }
  let!(:interest) { create :interest, user: user }
  let(:service) { described_class.new(interest, params) }

  describe '#create' do
    let(:params) do
      {
        text: text,
        user_id: user.id
      }
    end
    let(:submission) { interest.submissions.first }

    subject { service.create }

    context 'note submission' do
      let(:text) { 'Very important note' }

      it 'should create submission' do
        subject
        expect(interest.submissions.size).to eq 1
        expect(submission.text).to eq('Very important note')
      end

      it 'should not create note' do
        subject
        expect(submission.reload.note).to be_nil
      end

    end

    context 'submission with hashtags' do
      let(:text) { '#idea Very important note #article more' }

      it 'should create submission' do
        subject
        expect(interest.submissions.size).to eq 1
      end

      it 'should create two tags' do
        subject
        expect(Tag.count).to eq(2)
        expect(submission.tags.pluck(:name)).to eq(['idea', 'article'])
      end

      it 'should not strip hashtags from submission text' do
        subject
        expect(submission.text).to eq('#idea Very important note #article more')
      end
    end

    context 'submission with link' do
      let(:text) { 'Very important note http://github.com' }
      let(:link) { submission.link }

      context 'successful response' do
        context 'successfull parsing' do

          shared_examples_for :successful_link_creation do |extension|

            let(:url) do
              return 'http://github.com' unless extension
              "http://github.com/index#{extension}"
            end

            it 'should create submission' do
              subject
              expect(interest.submissions.size).to eq 1
              expect(submission.text).to eq("Very important note #{url}")
            end

            it 'should create submission link' do
              subject
              expect(link).to be_persisted
              expect(link.title).to eq('Build software better, together')
              expect(link.description).to eq('GitHub is where people build software.')
              expect(link.domain).to eq('github.com')
              expect(link.image).to eq('https://assets-cdn.github.com/images/modules/open_graph/github-logo.png')
            end
          end

          context 'link to a web page' do
            context 'without extension' do
              before do
                ExternalRequestSupport.mock_success_page_request('http://github.com/')
              end

              include_examples :successful_link_creation, nil
            end

            %w(.html .htm .shtml .phtml .php .php3 .php4 .asp .aspx .axd .asx .asmx .ashx .cfm .jsp .yaws .jspx).each do |ext|
              context "with #{ext} extension" do
                let(:text) { "Very important note http://github.com/index#{ext}" }
                before do
                  ExternalRequestSupport.mock_success_page_request("http://github.com/index#{ext}")
                end

                include_examples :successful_link_creation, ext
              end
            end
          end

          context 'link to an image' do
            %w(.jpg .png .gif .bmp).each do |ext|
              context "image with #{ext} extendion" do
                let(:text) { "Very important note http://example.com/sample#{ext}" }
                let(:image) { submission.image }

                before do
                  ExternalRequestSupport.mock_success_image_request("http://example.com/sample#{ext}")
                end

                it 'should create submission' do
                  subject
                  expect(interest.submissions.size).to eq 1
                  expect(submission.text).to eq("Very important note http://example.com/sample#{ext}")
                end

                it 'should create submission image' do
                  subject
                  expect(image).to be_persisted
                  expect(image.title).to eq("sample#{ext}")
                  expect(image.domain).to eq('example.com')
                  expect(image.url).to eq("http://example.com/sample#{ext}")
                end
              end
            end
          end

          context 'link to a pdf file' do
            let(:text) { 'Very important note http://example.com/sample.pdf' }
            let(:attachment) { submission.attachment }

            before do
              ExternalRequestSupport.mock_success_pdf_request('http://example.com/sample.pdf')
            end

            it 'should create submission' do
              subject
              expect(interest.submissions.size).to eq 1
              expect(submission.text).to eq('Very important note http://example.com/sample.pdf')
            end

            it 'should create submission attachment' do
              subject
              expect(attachment).to be_persisted
              expect(attachment.title).to eq('sample.pdf')
              expect(attachment.format).to eq('pdf')
              expect(attachment.domain).to eq('example.com')
              expect(attachment.url).to eq('http://example.com/sample.pdf')
            end
          end

          context 'link to a zip file' do
            let(:text) { 'A link to an archive http://example.com/sample.zip' }
            let(:attachment) { submission.attachment }

            it 'should create submission' do
              subject
              expect(interest.submissions.size).to eq 1
              expect(submission.text).to eq('A link to an archive http://example.com/sample.zip')
            end

            it 'should create submission attachment' do
              subject
              expect(attachment).to be_persisted
              expect(attachment.title).to eq('sample.zip')
              expect(attachment.format).to eq('zip')
              expect(attachment.domain).to eq('example.com')
              expect(attachment.url).to eq('http://example.com/sample.zip')
            end
          end

          context 'link to a txt file' do
            let(:text) { 'A link to an archive http://example.com/sample.txt' }
            let(:attachment) { submission.attachment }

            it 'should create submission' do
              subject
              expect(interest.submissions.size).to eq 1
              expect(submission.text).to eq('A link to an archive http://example.com/sample.txt')
            end

            it 'should create submission attachment' do
              subject
              expect(attachment).to be_persisted
              expect(attachment.title).to eq('sample.txt')
              expect(attachment.format).to eq('txt')
              expect(attachment.domain).to eq('example.com')
              expect(attachment.url).to eq('http://example.com/sample.txt')
            end
          end
        end

        context 'unsuccessfull parsing' do
          before do
            ExternalRequestSupport.mock_success_page_request('http://github.com/', false)
          end

          it 'should create submission' do
            subject
            expect(submission).to be_persisted
            expect(submission.text).to eq('Very important note http://github.com')
          end

          it 'should create submission link' do
            subject
            expect(link).to be_persisted
            expect(link.title).to eq('Build software better, together')
            expect(link.description).to eq('No content')
            expect(link.domain).to eq('github.com')
            expect(link.image).to eq('https://assets-cdn.github.com/images/modules/open_graph/github-logo.png')
          end
        end
      end

      context 'not found response' do
        before do
          ExternalRequestSupport.mock_failed_request('http://github.com/')
        end

        it 'should create submission' do
          subject
          expect(submission).to be_persisted
          expect(submission.text).to eq('Very important note http://github.com')
        end

        it 'should not create submission link' do
          subject
          expect(link).to be_persisted
          expect(link.title).to eq('http://github.com')
          expect(link.description).to eq('No content')
          expect(link.domain).to eq('github.com')
          expect(link.image).to eq('http://placehold.it/50x50')
        end
      end
    end
  end
end
