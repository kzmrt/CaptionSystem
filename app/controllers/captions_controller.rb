# frozen_string_literal: true

require 'rubyXL'

class CaptionsController < ApplicationController
  def index
    @captions = Caption.all

    # テンプレートの読み込み
    workbook = RubyXL::Parser.parse('app/assets/template.xlsx')
    workbook.calc_pr.full_calc_on_load = true
    workbook.calc_pr.calc_completed = true
    workbook.calc_pr.calc_on_save = true
    workbook.calc_pr.force_full_calc = true

    # 一番目のワークシート読み込み
    worksheet = workbook[0]

    # データ書き込み
    num = 1
    @captions.each{|caption|
      worksheet[num][0].change_contents(caption.title)    # タイトル
      worksheet[num][1].change_contents(caption.name)     # 作者名
      worksheet[num][2].change_contents(caption.size)     # サイズ
      worksheet[num][3].change_contents(caption.supplies) # 画材
      worksheet[num][4].change_contents(caption.price)    # 値段
      puts "title: " + caption.title
      if caption.memo.blank?
        worksheet[num][5].change_contents("")
      else
        worksheet[num][5].change_contents(caption.memo)    # コメント
      end
      num += 1
    }

    respond_to do |format|
      format.html
      format.xlsx do
       send_data workbook.stream.read,
         filename: "Caption.xlsx".encode(Encoding::Windows_31J)
      end
    end
  ensure
    workbook.stream.close
    puts "streamを閉じました"
  end

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
