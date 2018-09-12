# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @user = current_user
    if @user.admin?
      @captions = Caption.order('created_at desc').page params[:page]
    else
      @captions = @user.captions.order('created_at desc').page params[:page]
    end
  end
end
