class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers, :giveCharma]
  def index
    @users = User.paginate(page: params[:page])
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC")
      @posts = Post.search(params[:search]).order("created_at DESC")
    else
      @users = User.all.order('created_at DESC')
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.reorder("created_at DESC").paginate(page: params[:page], per_page: 10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    session[:user_id] = @user.id
    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    redirect_to root_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:handle.downcase, :name, :email, :password, :password_confirmation, :avatar)
  end

end
