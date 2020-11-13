class IdeasController < ApplicationController
  def index
    # ideaの一覧をjson形式で返す
    ideas = Idea.all
    if params[:name]
      category = Category.find_by(name: params[:name])
      # カテゴリ名が無かった場合はエラーを返す
      if category.nil?
        render body: nil, status: 404
        return
      end
      ideas = ideas.where(category_id: category.id)
    end
    # jsonフォーマット
    results = []
    ideas.each do |idea|
      results.append({
                       id: idea.id,
                       category: Category.find(idea.category_id).name,
                       body: idea.body
                     })
    end
    render json: { date: results }
  end

  def create
    # POSTリクエストのカテゴリ名があるか探す
    category = Category.find_by(name: params[:category_name])
    # 無かった場合に新しく作成
    unless category
      category = Category.new(name: params[:category_name])
      # 保存できなかった場合にエラーコードを返す
      unless category.save
        render body: nil, status: 422
        return
      end
    end
    # ideaテーブルに保存
    idea = Idea.new(category_id: category.id, body: params[:body])
    # 保存できなかった場合にエラーコードを返す
    unless idea.save
      render body: nil, status: 422
      return
    end
    # 保存に成功したらコードを返す。
    render body: nil, status: 201
  end
end
