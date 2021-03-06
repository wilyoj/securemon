class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end 
  
  def index
    #@users = User.all
    @users = User.paginate(:page => params[:page])
  end
  
  def create
    @user =  User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Login successful, welcome to your securemon profile"
      redirect_to @user
    else
      render 'new'
    end
  end 
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_url
  end
    
    
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
    
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in"
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
