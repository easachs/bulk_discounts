class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_amount
    invoice_items
    .joins(:bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.quantity')
    .select('max(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percent / 100.0)')
    .group(:id).sum(&:max)
  end

  def discounted_revenue
    total_revenue - discounted_amount
  end
end
