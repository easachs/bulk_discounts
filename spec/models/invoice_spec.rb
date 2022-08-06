require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions }
    it { should have_many(:invoice_items) }
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    describe "discounted_amount/revenue" do
      it "ex 1: no discounts applied" do
        @merchant = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant.id)
        @customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice = Invoice.create!(customer_id: @customer.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2) # 50 +
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id, quantity: 5, unit_price: 10, status: 1) # 50 = 100
        @discount = @merchant.bulk_discounts.create!(quantity: 10, percent: 25)

        expect(@invoice.total_revenue).to eq(100)
        expect(@invoice.discounted_amount).to eq(0)
        expect(@invoice.discounted_revenue).to eq(100)
      end

      it "ex 2: one item with discount applied, one not" do
        @merchant = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant.id)
        @customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice = Invoice.create!(customer_id: @customer.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2) # 100 -> 75 +
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id, quantity: 5, unit_price: 10, status: 1) # 50 -> 50 = 125
        @discount = @merchant.bulk_discounts.create!(quantity: 10, percent: 25)

        expect(@invoice.total_revenue).to eq(150)
        expect(@invoice.discounted_amount).to eq(25)
        expect(@invoice.discounted_revenue).to eq(125)
      end

      it "ex 3: items with different discounts applied" do
        @merchant = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant.id)
        @customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice = Invoice.create!(customer_id: @customer.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_1.id, quantity: 20, unit_price: 10, status: 2) # 200 -> 100 +
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id, quantity: 10, unit_price: 10, status: 1) # 100 -> 75 = 175
        @discount_1 = @merchant.bulk_discounts.create!(quantity: 10, percent: 25)
        @discount_2 = @merchant.bulk_discounts.create!(quantity: 15, percent: 50)

        expect(@invoice.total_revenue).to eq(300)
        expect(@invoice.discounted_amount).to eq(125)
        expect(@invoice.discounted_revenue).to eq(175)
      end

      it "ex 4: two discounts, one impossible" do
        @merchant = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant.id)
        @customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice = Invoice.create!(customer_id: @customer.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2) # 100 -> 75 +
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id, quantity: 10, unit_price: 10, status: 1) # 100 -> 75 = 150
        @discount_1 = @merchant.bulk_discounts.create!(quantity: 10, percent: 25)
        @discount_2 = @merchant.bulk_discounts.create!(quantity: 20, percent: 20) #never

        expect(@invoice.total_revenue).to eq(200)
        expect(@invoice.discounted_amount).to eq(50)
        expect(@invoice.discounted_revenue).to eq(150)
      end

      it "ex 5: two merchants, one with two discounts one without" do
        @merchant_1 = Merchant.create!(name: 'Hair Care')
        @merchant_2 = Merchant.create!(name: 'Eye Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant_1.id)
        @item_3 = Item.create!(name: "Glasses", description: "Helps you see good", unit_price: 20, merchant_id: @merchant_2.id)
        @item_4 = Item.create!(name: "Sunglasses", description: "Sun is bright", unit_price: 15, merchant_id: @merchant_2.id)
        @customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice = Invoice.create!(customer_id: @customer.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2) # 100 -> 75 +
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id, quantity: 20, unit_price: 10, status: 1) # 200 -> 100 +
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_3.id, quantity: 10, unit_price: 10, status: 1) # 100 +
        @ii_4 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_4.id, quantity: 20, unit_price: 10, status: 1) # 200 = 475
        @discount_1 = @merchant_1.bulk_discounts.create!(quantity: 10, percent: 25)
        @discount_2 = @merchant_1.bulk_discounts.create!(quantity: 15, percent: 50)
        
        expect(@invoice.total_revenue).to eq(600)
        expect(@invoice.discounted_amount).to eq(125)
        expect(@invoice.discounted_revenue).to eq(475)
      end
    end
  end
end
