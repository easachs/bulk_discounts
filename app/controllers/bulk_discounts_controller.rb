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
    @merchant.bulk_discounts.create!(discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def destroy
    @discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
  end

  def update
    @discount.update(discount_params)
    redirect_to merchant_bulk_discount_path(@discount.merchant, @discount)
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