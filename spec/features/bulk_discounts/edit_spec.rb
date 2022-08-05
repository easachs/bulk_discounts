require 'rails_helper'

RSpec.describe 'discounts edit' do
    before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @discount_1 = @merchant1.bulk_discounts.create!(percent: 10, quantity: 10)

    visit edit_merchant_bulk_discount_path(@merchant1, @discount_1)
  end

  it 'has form to edit discount' do
    fill_in "Percent", with: 30
    fill_in "Quantity", with: 5
    click_button "Edit"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount_1))
    expect(page).to have_content("Discount ID: #{@discount_1.id}")
    expect(page).to_not have_content("10% off 10 items")
    expect(page).to have_content("30% off 5 items")
  end
end