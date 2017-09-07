class OrdersController < ApplicationController
  include ChessStoreHelpers::Cart
  def index
    @orders = Order.all.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @order = Order.find(params[:id])
    @orders_not_shipped =  Order.not_shipped.to_a unless current_user.nil?
  end

  def new
  end

  def update
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_path, notice: "Successfully cancelled order."
  end

  def cart
    @cart_items = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @grand_total = calculate_cart_items_cost + calculate_cart_shipping
  end

  def empty_cart
    clear_cart
  end

  def checkout
    @cart_items = get_list_of_items_in_cart
    @order = Order.new
    if !current_user.orders.all.empty?
      @last_school = current_user.orders.chronological.last.school.id
    end
    @schools = School.alphabetical.all
    @grand_total = calculate_cart_items_cost + calculate_cart_shipping
  end

  def create
    @order = Order.new(order_params)
    @order.grand_total = calculate_cart_items_cost + calculate_cart_shipping
    if @order.save
      @order.date = Date.current
      @order.pay
      @order.save
      save_each_item_in_cart(@order)
      
      clear_cart
      redirect_to @order, notice: "Your order has been placed. Thank you!"
    else
      flash[:error] = "Invalid credit card information, please try again!"
      redirect_to checkout_path
    end
  end

private
  def order_params
    params[:order][:expiration_month] = params[:order][:expiration_month].to_i
    params[:order][:expiration_year] = params[:order][:expiration_year].to_i
    params.require(:order).permit(:date, :school_id, :user_id, :grand_total, :credit_card_number, :expiration_year, :expiration_month)
  end
end


