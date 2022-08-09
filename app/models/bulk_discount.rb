class BulkDiscount < ApplicationRecord
  validates :quantity, numericality: {only_integer: true, greater_than_or_equal_to: 2}
  validates :percent, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99}
  validates_presence_of :merchant_id

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
end