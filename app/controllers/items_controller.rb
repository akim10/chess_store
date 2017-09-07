class ItemsController < ApplicationController
  include ChessStoreHelpers::Cart
  authorize_resource
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :check_login, only: [:edit, :create, :update, :destroy]

  def index
    # get info on active items for the big three...
    @boards = Item.active.for_category('boards').alphabetical.paginate(:page => params[:page]).per_page(12)
    @pieces = Item.active.for_category('pieces').alphabetical.paginate(:page => params[:page]).per_page(12)
    @clocks = Item.active.for_category('clocks').alphabetical.paginate(:page => params[:page]).per_page(12)
    @supplies = Item.active.for_category('supplies').alphabetical.paginate(:page => params[:page]).per_page(12)    
    # get a list of any inactive items for sidebar
    @inactive_items = Item.inactive.alphabetical.to_a
  end

  def show
    # get the price history for this item
    @price_history = @item.item_prices.chronological.wholesale.to_a
    @manufacturer_price_history = @item.item_prices.chronological.manufacturer.to_a
    # everyone sees similar items in the sidebar
    @similar_items = Item.for_category(@item.category).active.alphabetical.to_a - [@item]
  end

  def new
    @item = Item.new
    @item.item_prices.build
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      @price_history = @item.item_prices.chronological.wholesale.to_a
      @manufacturer_price_history = @item.item_prices.chronological.manufacturer.to_a
      redirect_to item_path(@item), notice: "Successfully created #{@item.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: "Successfully updated #{@item.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "Successfully removed #{@item.name} from the system."
  end

  def add_to_cart
    add_item_to_cart(params[:id])
    @item = Item.find(params[:id])
    redirect_to item_path(@item), notice: "#{@item.name} added to cart."
  end

  def remove_from_cart
    remove_item_from_cart(params[:id])
    @item = Item.find(params[:id])
    redirect_to item_path(@item), notice: "Removed #{@item.name} from cart"
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :color, :category, :weight, :inventory_level, :reorder_level, :active, :picture)
  end
  
end