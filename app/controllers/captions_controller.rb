# frozen_string_literal: true

class CaptionsController < ApplicationController
  def new
    flash.now[:notice] = 'キャプション情報を入力してください。'
    @caption = Caption.new
  end

  def edit
    flash.now[:notice] = 'キャプション情報を編集してください。'
    @caption = find_caption_by_id
  end

  def create
    if current_user.captions.create(caption_params)
      flash[:notice] = '登録しました。'
    else
      flash[:error] = '登録に失敗しました。'
    end

    redirect_to :root
  end

  def update
    @caption = find_caption_by_id
    @caption.update(caption_params)
    flash[:notice] = '更新しました。'

    redirect_to :root
  end

  def destroy
    @caption = find_caption_by_id
    @caption.destroy
    flash[:notice] = '削除しました。'

    redirect_to :root
  end

  protected

  def caption_params
    params.require(:caption).permit(:title, :name, :size, :supplies, :price, :memo)
  end

  def find_caption_by_id
    Caption.find(params[:id])
  end
end
