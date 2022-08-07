class BulkDiscount < ApplicationRecord
  validates_numericality_of :quantity, greater_than_or_equal_to: 2
  validates_numericality_of :percent, inclusion: 1..99
  validates_presence_of :merchant_id

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
end