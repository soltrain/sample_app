class UsersController < ApplicationController
  #catch attempts to access edit/update for anyone not signed in
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  #catch attempts to access edit/update for anyone but current user
  before_action :correct_user, only: [:edit, :update] 
  before_action :admin_user, only: :destroy

  def new
  	@user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    #previously had @user = User.find(params[:id])
    #now covered by the correct user before action
  end

  def update
    #see note for edit
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end



  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  #before filters

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end

    #following is the same as:
    #unless signed_in?
    #flash[:notice] = "Please sign in."
    #redirect_to signin_url
    #here it is: 
    #redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end


end

