class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'open-uri'

  private

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end
end
