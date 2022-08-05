class BulkDiscount < ApplicationRecord
  validates_presence_of :quantity,
                        :percent,
                        :merchant_id

  belongs_to :merchant
end