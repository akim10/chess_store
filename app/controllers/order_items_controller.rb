class OrderItemsController < ApplicationController
  before_action :check_login
  authorize_resource
  
  def ship
    @order_item = OrderItem.find(params[:id])
    @order_item.shipped
    respond_to do |format|
      if @order_item.save!
        @unshipped_order_items = OrderItem.unshipped.to_a
        format.js
      end
    end
  end

  def nonajax_ship
    @order_item = OrderItem.find(params[:id])
    @order_item.shipped
    if @order_item.save!
      @unshipped_order_items = OrderItem.unshipped.to_a
      redirect_to order_path(@order_item.order)
    end
  end

end