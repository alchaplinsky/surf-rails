class Link < ApplicationRecord

  belongs_to :submission, inverse_of: :link
  validates_presence_of :submission, :title, :url, :description, :image, :domain
end
