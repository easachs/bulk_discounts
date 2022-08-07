class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create, :destroy]
  before_action :find_discount, only: [:show, :edit, :update, :destroy]

  def index
    @holidays = HolidaySearch.new
  end

  def show
  end

  def new
  end

  def create
    discount = @merchant.bulk_discounts.new(discount_params)
    if discount.save
      flash.notice = "Discount has been created!"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.notice = "Error: All fields must be valid integers."
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    @discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
  end

  def update
    if @discount.update(discount_params)
      flash.notice = "Discount has been updated!"
      redirect_to merchant_bulk_discount_path(@discount.merchant, @discount)
    else
      flash.notice = "Error: All fields must be valid integers."
      redirect_to edit_merchant_bulk_discount_path(@discount.merchant, @discount)
    end
  end

  private
  def discount_params
    params.permit(:percent, :quantity)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_discount
    @discount = BulkDiscount.find(params[:id])
  end
end