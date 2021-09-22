class Image < ApplicationRecord
  belongs_to :submission
  validates_presence_of :submission, :title, :domain, :url
end
