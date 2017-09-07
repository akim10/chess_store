class UsersController < ApplicationController
  include ChessStoreHelpers::Cart
  def new
    @user = User.new
  end

  def index
    @users = User.all.paginate(:page => params[:page]).per_page(8)
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to(home_path, :notice => 'User was successfully created.')
      create_cart
    else
      render :action => "new"
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def show
    @user = User.find(params[:id])
    @order_history = @user.orders
  end

  def destroy
    redirect_to(user_path, :notice => 'User was successfully deactivated.')
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active)
  end

end