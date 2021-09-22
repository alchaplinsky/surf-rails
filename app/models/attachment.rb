class Attachment < ApplicationRecord
  belongs_to :submission
  validates_presence_of :submission, :title, :format, :domain, :url
end
