class PostsController < ApplicationController
  #require a user being logged in to create a post

  before_action :require_user, only: [:new, :create]

  def create
    @post = Post.new(post_params)

    if @post.post_text.length <= current_user.charma
      @post.update(user_id: current_user.id)
    end
      redirect_to root_path
  end

  def index
    if logged_in?
    @posts = current_user.feed.paginate(page: params[:page], per_page: 10)
    @leaderboard = Post.order("created_at DESC").limit(5)
    respond_to do |format|
      format.html
      format.js
    end
    end
  end

  def show
  end

  def new
  end

  def update
  end

  def destroy
    @post = Post.find(params[:id])
    if ((current_user.charma - @post.votes_for.size) < 1)
      current_user.update(charma: 1)
    else
      current_user.update(charma: current_user.charma - @post.votes_for.size)
      @post.votes_for.each do |vote|
        User.find(vote.voter_id).increment!(:charma)
      end
    end
      @post.destroy
      redirect_to root_path
  end

  def giveCharma
    @post = Post.find(params[:id])
    if ((current_user.charma > 1) && (current_user != @post.user))
      @post.user.increment!(:charma)
      current_user.decrement!(:charma)
      @post.liked_by current_user
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :no_content }
        format.js   { render :layout => false }
      end
    end
  end

  def takeCharma
    @post = Post.find(params[:id])
    if ((current_user != @post.user) && (@post.user.charma > 1))
      @post.user.decrement!(:charma)
      current_user.increment!(:charma)
      @post.unliked_by current_user
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :no_content }
        format.js   { render :layout => false }
     end
   end
  end

  #create post parameters

  private

  def post_params
    params.require(:post).permit(:post_text)
  end
end
