class ApplicationController < ActionController::Base
  include ChessStoreHelpers::Cart
  include ChessStoreHelpers::Shipping
  before_action :initialize_cart
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # helper_method :current_user
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You aren't authorized to access this page!"
    redirect_to home_path
  end

  def initialize_cart
    unless session[:cart].nil?
      @cart_items = get_list_of_items_in_cart
      @order = Order.new
      @shipping_costs = calculate_cart_shipping
      @grand_total = calculate_cart_items_cost + calculate_cart_shipping
    end
  end
end
