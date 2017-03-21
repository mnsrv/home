class SessionsController < ApplicationController
  def new
    @title = 'Вход'
    @subtitle = 'Скажи &laquo;друг&raquo;&nbsp;&mdash; и&nbsp;войдешь'
  end

  def create
    user = User.authenticate(params["email"], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now.alert = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
