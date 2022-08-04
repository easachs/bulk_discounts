require 'rails_helper'

RSpec.describe 'discounts show' do
    before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Jewelry')

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id, status: 1)

    @discount_1 = @merchant1.bulk_discounts.create!(percent: 10, quantity: 10)
    @discount_2 = @merchant1.bulk_discounts.create!(percent: 20, quantity: 15)
    @discount_3 = @merchant2.bulk_discounts.create!(percent: 50, quantity: 50)

    visit merchant_bulk_discount_path(@merchant1, @discount_1)
  end

  it 'displays bulk discount quantity and percentage' do
    expect(page).to have_content("Discount ID: #{@discount_1.id}")
    expect(page).to have_content("10% off 10 items")
    expect(page).to_not have_content("Discount ID: #{@discount_2.id}")
    expect(page).to_not have_content("20% off 15 items")
    expect(page).to_not have_content("50% off 50 items")
  end
end