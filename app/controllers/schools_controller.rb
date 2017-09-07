class SchoolsController < ApplicationController
  def index
    @schools = School.all.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @school = School.find(params[:id])
    @order_history = @school.orders
  end

  def new
    @school = School.new
    @active_schools = School.all.alphabetical.active.map{|s| s.name}
  end

  def create
    @school = School.new(school_params)
    @active_schools = School.all.alphabetical.active.map{|s| s.name}
    if @school.save
      flash[:notice] = "Added #{@school.name}!"
      if current_user.nil?
        redirect_to new_user_path
      else
        redirect_to checkout_path
      end
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def school_params
    params.require(:school).permit(:name, :street_1, :street_2, :city, :state, :zip, :min_grade, :max_grade, :active)
  end
end