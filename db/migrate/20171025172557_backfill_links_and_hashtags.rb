class BackfillLinksAndHashtags < ActiveRecord::Migration[5.1]
  def up
    Submission.includes(:link, :note, :image, :attachment, :tags).find_each do |submission|
      if submission.link.present?
        submission.text += ' ' + submission.link.url
      end
      if submission.image.present?
        submission.text += ' ' + submission.image.url
      end
      if submission.attachment.present?
        submission.text += ' ' + submission.attachment.url
      end
      if submission.tags.size > 0
        submission.text += ' #' + submission.tags.map(&:name).join(' #')
      end
      submission.save
    end
  end

  def down
  end
end
