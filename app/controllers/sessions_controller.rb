class SessionsController < ApplicationController
  def create
    @user = User.find_by_handle(params[:session][:handle].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:danger] = 'Invalid email/password combination'
      redirect_to new_user_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
