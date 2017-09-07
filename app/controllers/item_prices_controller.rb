class ItemPricesController < ApplicationController
  authorize_resource
  before_action :check_login, only: [:new, :create]

  def index
    @active_items = Item.active.alphabetical.to_a
  end

  def new
    @item_price = ItemPrice.new
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.current
    respond_to do |format|
      if @item_price.save
        format.html { redirect_to item_path(@item), notice: "Changed the price of #{@item.name}." }
        @item = @item_price.item
        @price_history = @item.item_prices.chronological.wholesale.to_a
        @manufacturer_price_history = @item.item_prices.chronological.manufacturer.to_a
        format.js
      else
        render action: 'new'
      end
    end
  end

  private
  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :category)
  end
  
end
