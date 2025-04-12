class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    # buildメソッドはデータベースに反映されない
    # micropostsはテーブル名
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      # マイクロポストが向こうな場合での対処
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end
end
