class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update index destroy]
  before_action :correct_user, only: %i[edit update show]
  before_action :admin_user, only: :destroy
  # editアクションとupdateアクションの前にログインしているかを確認するlogged_in_userメソッドが実行される
  # ログインしていない場合、login画面にリダイレクトされる。
  # ユーザー情報を確認できるとまずいので、showアクションの前にも必要じゃない？
  def new
    @user = User.new
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
    # 各ページに表示するユーザーを@usersに格納する。
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def create
    # これはsiginupするときに実行されるメソッド
    @user = User.new(user_params)
    # user_paramsメソッドを実行した時の戻り値を引数として設定している。
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def edit; end

  def destroy
    User.find(params[:id]).destroy
    # ActiveRecordのdestroyメソッドを使ってユーザーを削除する。
    flash[:success] = 'User deleted'
    redirect_to users_url, status: :see_other
    # users_url => /users
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # ここのメソッドの意味としては、userシンボルが必須
    # 名前、メールアドレス、パスワード、パスワード確認のみが許可されている。
  end

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    store_location
    # セッション変数にforwarding_urlを保存する。
    flash[:danger] = 'Please log in.'
    redirect_to login_url, status: :see_other
    # おそらくこの行を編集する。
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
    # current_userメソッドに引数として、インスタンス変数を渡している。
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
