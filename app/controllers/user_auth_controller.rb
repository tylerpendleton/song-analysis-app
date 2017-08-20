class UserAuthController < ApplicationController
  def index
    if params.has_key?(:code)
      create_user_auth
      redirect_to root_path
    else
      return
    end
  end

  def create
  end
end
