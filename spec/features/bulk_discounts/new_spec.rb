require 'rails_helper'

RSpec.describe 'discounts new' do
    before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @discount_1 = @merchant1.bulk_discounts.create!(percent: 10, quantity: 10)
    @discount_2 = @merchant1.bulk_discounts.create!(percent: 20, quantity: 15)

    visit new_merchant_bulk_discount_path(@merchant1)
  end

  it 'has form to add new discount' do
    fill_in "Percent", with: 30
    fill_in "Quantity", with: 5
    click_button "Create"

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_content("Discount has been created!")
    expect(page).to have_link("10% off 10 items")
    expect(page).to have_link("20% off 15 items")

    expect(page).to have_link("30% off 5 items")
  end

  it 'sad paths' do
    fill_in "Percent", with: 'XYZ'
    fill_in "Quantity", with: 5
    click_on "Create"

    expect(page).to have_content("Error: All fields must be valid integers.")

    fill_in "Percent", with: 30
    fill_in "Quantity", with: 'XYZ'
    click_on "Create"

    expect(page).to have_content("Error: All fields must be valid integers.")
  end
end