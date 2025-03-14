class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    #このuser_paramの設定は別途する必要がある。
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      #redirect_to user_url(@user)　と同等のコード
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
    end

end
