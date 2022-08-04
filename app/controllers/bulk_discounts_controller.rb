class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create]

  def index
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
  end

  def create
    @merchant.bulk_discounts.create!(discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def discount_params
    params.permit(:percent, :quantity)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end