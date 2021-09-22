class Tagging < ApplicationRecord

  belongs_to :tag
  belongs_to :submission
  validates_presence_of :tag, :submission

end
