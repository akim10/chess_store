class PurchasesController < ApplicationController
  authorize_resource
  before_action :check_login, only: [:index, :new, :create]

  def index
    @purchases = Purchase.chronological.to_a
  end

  def new
    @purchase = Purchase.new
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.date = Date.current
    respond_to do |format|
      if @purchase.save
        format.html { redirect_to purchases_path, notice: "Successfully added a purchase for #{@purchase.quantity} #{@purchase.item.name}." }
        @item = @purchase.item
        @items_to_reorder = Item.need_reorder.alphabetical.to_a
        format.js
      else
        render action: 'new'
      end
    end
  end

  private
  def purchase_params
    params.require(:purchase).permit(:item_id, :quantity)
  end
  
end