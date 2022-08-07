module DiscountRevenue
    def total_revenue
    invoice_items.sum("invoice_items.unit_price * invoice_items.quantity")
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