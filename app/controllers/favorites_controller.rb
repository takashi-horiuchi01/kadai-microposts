class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(micropost)
    flash[:success] = 'ポストをお気に入りに追加しました。'
    redirect_to root_url
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micropost)
    flash[:success] = 'ポストのお気に入りを解除しました。'
    redirect_to root_url
  end

end
