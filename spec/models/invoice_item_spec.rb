require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant) }
    
  end

  describe "class methods" do
    before(:each) do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end
  end

  describe "instance methods" do
    it "can find best discount" do
      merchant_1 = Merchant.create!(name: 'Hair Care')
      merchant_2 = Merchant.create!(name: 'Eye Care')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant_1.id, status: 1)
      item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant_1.id)
      item_3 = Item.create!(name: "Glasses", description: "Helps you see good", unit_price: 20, merchant_id: merchant_2.id)
      item_4 = Item.create!(name: "Sunglasses", description: "Sun is bright", unit_price: 15, merchant_id: merchant_2.id)
      customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice = Invoice.create!(customer_id: customer.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 10, unit_price: 10, status: 2) # 100 -> 75 +
      ii_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 20, unit_price: 10, status: 1) # 200 -> 100 +
      ii_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 10, unit_price: 10, status: 1) # 100 +
      ii_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 20, unit_price: 10, status: 1) # 200 = 475
      discount_1 = merchant_1.bulk_discounts.create!(quantity: 15, percent: 50)
      discount_2 = merchant_1.bulk_discounts.create!(quantity: 10, percent: 25)

      expect(ii_1.best_discount).to eq(discount_2)
      expect(ii_2.best_discount).to eq(discount_1)
      expect(ii_3.best_discount).to be_nil
      expect(ii_4.best_discount).to be_nil
    end
  end
end
