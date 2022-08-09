require 'rails_helper'

describe Merchant do
  describe "validations" do
    it { should validate_presence_of :name }
  end
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it {should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:bulk_discounts) }
  end

  describe "class methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')
      @merchant3 = Merchant.create!(name: 'Office Space')
      @merchant4 = Merchant.create!(name: 'The Office')
      @merchant5 = Merchant.create!(name: 'Office Improvement')
      @merchant6 = Merchant.create!(name: 'Pens & Stuff')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

      @item_9 = Item.create!(name: "Whiteboard", description: "Erasable", unit_price: 30, merchant: @merchant3)
      @item_10 = Item.create!(name: "Marker", description: "Erasable", unit_price: 3, merchant: @merchant4)
      @item_11 = Item.create!(name: "Eraser", description: "Felt", unit_price: 6, merchant: @merchant5)
      @item_12 = Item.create!(name: "Sharpie", description: "Permanent", unit_price: 4, merchant: @merchant6)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)

      @invoice_9 = Invoice.create!(customer: @customer_1, status: 2)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2, created_at: "2012-03-28 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-03-30 14:54:09")
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-01 14:54:09")
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1, created_at: "2012-04-02 14:54:09")
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1, created_at: "2012-04-03 14:54:09")
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_9.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_12 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_10.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_13 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_11.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_14 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_12.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
      @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_9.id)

    end

    it 'top_merchants' do
      actual = Merchant.top_merchants.map do |result|
        result.name
      end
      expect(actual).to eq([@merchant1.name, @merchant3.name, @merchant4.name, @merchant5.name, @merchant6.name])
    end
  end

  describe "instance methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2, created_at: "2012-03-28 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-03-30 14:54:09")
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-01 14:54:09")
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1, created_at: "2012-04-02 14:54:09")
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1, created_at: "2012-04-03 14:54:09")
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)

    end
    it "can list items ready to ship" do
      expect(@merchant1.ordered_items_to_ship).to eq([@item_1, @item_1, @item_3, @item_4, @item_7, @item_8, @item_4, @item_4])
    end

    it "shows a list of favorite customers" do
      actual = @merchant1.favorite_customers.map do |customer|
        customer[:first_name]
      end
      expect(actual).to eq([@customer_1.first_name, @customer_2.first_name, @customer_3.first_name, @customer_4.first_name, @customer_6.first_name])
    end

    it "top_5_items" do
      expect(@merchant1.top_5_items).to eq([@item_1, @item_2, @item_3, @item_8, @item_4])
    end

    it "best_day" do
      expect(@merchant1.best_day).to eq(@invoice_8.created_at.to_date)
    end

    describe "instance methods" do
      it "total_revenue" do
        @merchant_1 = Merchant.create!(name: 'Hair Care')
        @merchant_2 = Merchant.create!(name: 'Eye Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant_1.id)
        @item_3 = Item.create!(name: "Glasses", description: "Helps you see good", unit_price: 20, merchant_id: @merchant_2.id)
        @item_4 = Item.create!(name: "Sunglasses", description: "Sun is bright", unit_price: 15, merchant_id: @merchant_2.id)
        @customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice = Invoice.create!(customer_id: @customer.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2) # 100 +
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id, quantity: 20, unit_price: 10, status: 1) # 200 = 300
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_3.id, quantity: 10, unit_price: 10, status: 1) # not counted
        @ii_4 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_4.id, quantity: 20, unit_price: 10, status: 1) # not counted
        @discount_1 = @merchant_1.bulk_discounts.create!(quantity: 10, percent: 25)
        @discount_2 = @merchant_1.bulk_discounts.create!(quantity: 15, percent: 50)

        expect(@merchant_1.total_invoice_revenue(@invoice)).to eq(300)
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

          expect(@merchant.total_invoice_revenue(@invoice)).to eq(100)
          expect(@merchant.discounted_invoice_amount(@invoice)).to eq(0)
          expect(@merchant.discounted_invoice_revenue(@invoice)).to eq(100)
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

          expect(@merchant.total_invoice_revenue(@invoice)).to eq(150)
          expect(@merchant.discounted_invoice_amount(@invoice)).to eq(25)
          expect(@merchant.discounted_invoice_revenue(@invoice)).to eq(125)
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

          expect(@merchant.total_invoice_revenue(@invoice)).to eq(300)
          expect(@merchant.discounted_invoice_amount(@invoice)).to eq(125)
          expect(@merchant.discounted_invoice_revenue(@invoice)).to eq(175)
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

          expect(@merchant.total_invoice_revenue(@invoice)).to eq(200)
          expect(@merchant.discounted_invoice_amount(@invoice)).to eq(50)
          expect(@merchant.discounted_invoice_revenue(@invoice)).to eq(150)
        end

        it "ex 5: two merchants on an invoice" do
          @merchant_1 = Merchant.create!(name: 'Hair Care')
          @merchant_2 = Merchant.create!(name: 'Eye Care')
          @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
          @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant_1.id)
          @item_3 = Item.create!(name: "Glasses", description: "Helps you see good", unit_price: 20, merchant_id: @merchant_2.id)
          @item_4 = Item.create!(name: "Sunglasses", description: "Sun is bright", unit_price: 15, merchant_id: @merchant_2.id)
          @customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
          @invoice = Invoice.create!(customer_id: @customer.id, status: 2, created_at: "2012-03-27 14:54:09")
          @ii_1 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2) # 100 -> 75 +
          @ii_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id, quantity: 20, unit_price: 10, status: 1) # 200 -> 100 = 175
          @ii_3 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_3.id, quantity: 10, unit_price: 10, status: 1) # not counted
          @ii_4 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_4.id, quantity: 20, unit_price: 10, status: 1) # not counted
          @discount_1 = @merchant_1.bulk_discounts.create!(quantity: 10, percent: 25)
          @discount_2 = @merchant_1.bulk_discounts.create!(quantity: 15, percent: 50)
          
          expect(@merchant_1.total_invoice_revenue(@invoice)).to eq(300)
          expect(@merchant_1.discounted_invoice_amount(@invoice)).to eq(125)
          expect(@merchant_1.discounted_invoice_revenue(@invoice)).to eq(175)

          expect(@merchant_2.total_invoice_revenue(@invoice)).to eq(300)
          expect(@merchant_2.discounted_invoice_amount(@invoice)).to eq(0)
          expect(@merchant_2.discounted_invoice_revenue(@invoice)).to eq(300)
        end
      end
    end
  end
end
