class Note < ApplicationRecord
  include Hashid::Rails

  belongs_to :submission, inverse_of: :note
  validates_presence_of :submission, :text

end
