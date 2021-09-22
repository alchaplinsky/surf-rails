class BackfillSubmissionsTitlesAndText < ActiveRecord::Migration[5.1]
  def up
    Note.includes(:submission).find_each do |note|
      submission = note.submission
      submission.update_attributes(title: note.title, text: note.text)
    end
  end

  def down
  end
end
