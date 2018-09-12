# frozen_string_literal: true

class CaptionsController < ApplicationController
  def new
    flash.now[:notice] = 'キャプション情報を入力してください。'
    @caption = Caption.new
  end

  def edit
    @caption = find_caption_by_id
    if current_user.admin? || current_user.id == @caption.user.id
      flash.now[:notice] = 'キャプション情報を編集してください。'
    else
      flash[:error] = '編集権限がありません。'
      redirect_to :root
    end
  end

  def create
#    current_user.captions.create(caption_params)
    @caption = current_user.captions.new(caption_params)
    if @caption.save
      flash[:notice] = '登録しました。'
      redirect_to :root
    else
      flash.now[:error] = @caption.errors.full_messages
      render action: :new
    end
  end

  def update
    @caption = find_caption_by_id
    if @caption.update(caption_params)
      flash[:notice] = '更新しました。'
      redirect_to :root
    else
      flash.now[:error] = @caption.errors.full_messages
      render action: :edit
    end
  end

  def destroy
    @caption = find_caption_by_id
    if current_user.admin? || current_user.id == @caption.user.id
      @caption.destroy
      flash[:notice] = '削除しました。'
    else
      flash[:error] = '削除権限がありません。'
    end
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
