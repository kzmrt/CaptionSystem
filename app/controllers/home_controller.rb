# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @user = current_user
    @captions = Caption.order('created_at desc')
  end
end
