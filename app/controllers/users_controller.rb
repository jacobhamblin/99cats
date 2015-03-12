class UsersController < ApplicationController

  before_action :cats_index, except: [:show, :destroy]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in!(@user)
      redirect_to cats_url
    else
      redirect_to new_session_url
    end
  end

  protected
  def user_params
    self.params.require(:user).permit(:user_name, :password)
  end

  private

  def cats_index
    unless session[:session_token] == nil
      redirect_to cats_url
    end
  end

end
