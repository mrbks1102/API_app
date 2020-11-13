require 'rails_helper'

RSpec.describe 'Ideas', type: :request do
  fixtures :categories
  fixtures :ideas

  describe 'GETリクエスト' do
    example '全idea一覧' do
      get :'/ideas'
      expect(JSON.parse(response.body)['date'].count).to eq(2)
      expect(response).to have_http_status(200)
    end

    example 'リクエストを送ったカテゴリがあった場合idea一覧が表示される' do
      get :'/ideas', params: { name: 'アプリ' }
      expect(JSON.parse(response.body)['date'].count).to eq(1)
      expect(response).to have_http_status(200)
    end

    example 'リクエストを送ったカテゴリが無かった場合エラーコードを返す' do
      get :'/ideas', params: { name: 'カテゴリ' }
      expect(response).to have_http_status(404)
    end
  end

  describe 'POSTリクエスト' do
    example 'カテゴリ名がない場合、新規登録に成功する' do
      post :'/ideas', params: { category_name: 'プラットフォーム', body: 'Twitter' }
      expect(Category.find_by(name: 'プラットフォーム')).to be_present
      expect(Idea.find_by(body: 'Twitter')).to be_present
      expect(response).to have_http_status(201)
    end

    example 'カテゴリ名がある場合、新規登録に成功する' do
      post :'/ideas', params: { category_name: 'アプリ', body: 'Line' }
      expect(Idea.find_by(body: 'Line')).to be_present
      expect(response).to have_http_status(201)
    end

    example 'paramsにcategory_nameがない場合にエラーコードを返す' do
      post :'/ideas', params: { body: 'ファッション情報' }
      expect(response).to have_http_status(422)
    end

    example 'paramsにideaがない場合にエラーコードを返す' do
      post :'/ideas', params: { category_name: 'app2' }
      expect(response).to have_http_status(422)
    end
  end
end
