class Upgrade < ApplicationRecord
  belongs_to :user
  validates_presence_of :user_id, :order_id, :payer_id
end
