class SessionsController < ApplicationController
  before_action :cats_index, except: [:destroy]

  def create
    @user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if @user.nil?
      render :new
    else
      log_in!(@user)
      # update session
      redirect_to cats_url
    end
  end

  def new
    render :new
  end

  def destroy
    @user = User.find_by_session_token(session[:session_token])
    @user.reset_session_token!
    log_out!
    redirect_to new_session_url
  end

  private
  def cats_index
    redirect_to cats_url if !session[:session_token].nil?
  end

end
