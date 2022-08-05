require 'rails_helper'

RSpec.describe 'discounts index' do
    before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Jewelry')

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id, status: 1)

    @discount_1 = @merchant1.bulk_discounts.create!(percent: 10, quantity: 10)
    @discount_2 = @merchant1.bulk_discounts.create!(percent: 20, quantity: 15)
    @discount_3 = @merchant2.bulk_discounts.create!(percent: 50, quantity: 50)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  it 'lists bulk discounts with percentage and quantity as links to show page' do
    within "#discount-#{@discount_1.id}" do
      expect(page).to have_link("10% off 10 items")
    end
    within "#discount-#{@discount_2.id}" do
      expect(page).to have_link("#{@discount_2.percent}% off #{@discount_2.quantity} items")
    end
    expect(page).to_not have_link("50% off 50 items")

    click_link "10% off 10 items"
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount_1))
  end

  it 'can create a discount' do
    expect(page).to have_link("Create Discount")
    click_link "Create Discount"
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
  end

  it 'can delete a discount' do
    within "#discount-#{@discount_1.id}" do
      expect(page).to have_link("Delete")
    end
    within "#discount-#{@discount_2.id}" do
      expect(page).to have_link("Delete")
      click_link "Delete"
    end
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_link("10% off 10 items")
    expect(page).to_not have_link("20% off 15 items")
  end
end