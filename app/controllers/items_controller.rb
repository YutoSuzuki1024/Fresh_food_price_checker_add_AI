class ItemsController < ApplicationController
	before_action :authenticate_member!

  def index
  	# ユーザーに選択された地域に登録されている食品一覧を出す
  	# whereメソッドで地域絞り込みがかけられるよう、地域との中間テーブルと関連づけ
  	Item.left_joins(:relationship_item_areas)
  	@items = Item.left_joins(:relationship_item_areas).where( :relationship_item_areas => {:area_id => params[:area_id]} )
  	@vegetables = @items.where(genre_id: 1)
  	@fruits = @items.where(genre_id: 2)
  	@seafoods = @items.where(genre_id: 3)
  	@meats = @items.where(genre_id: 4)

  	@area = Area.find(params[:area_id])
  end

  def show
  	@item = Item.find(params[:id])
  	@posts = Post.where(item_id: params[:id])
  	@member = Member.find(current_member.id)

  	#口コミから、相場価格と特売日価格の平均値をそれぞれ算出
  	@market_price_average = Post.where(price_status: 1, item_id: params[:id]).average(:price)
  	@sale_price_average = Post.where(price_status: 0, item_id: params[:id]).average(:price)

  	#口コミから、相場価格と特売日価格の最安値を出している店舗をそれぞれ算出する
  	@market_price_minimum = Post.where(price_status: 1, item_id: params[:id]).order(:price).first
  	@sale_price_minimum = Post.where(price_status: 0, item_id: params[:id]).order(:price).first
  end
end
