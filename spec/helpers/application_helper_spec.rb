# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#page_title' do
    context '@titleが指定されていない場合' do
      it 'デフォルトタイトルが返されること' do
        stub_const('ApplicationHelper::APP_NAME', 'Caption System')
        expect(helper.page_title).to eq('Caption System')
      end
    end

    context '@titleが指定されている場合' do
      before do
        assign(:title, 'hoge')
      end

      it 'ページタイトルに@titleが入った文字列が返されること' do
        stub_const('ApplicationHelper::APP_NAME', 'Caption System')
        expect(helper.page_title).to eq('Caption System | hoge')
      end
    end
  end
end
