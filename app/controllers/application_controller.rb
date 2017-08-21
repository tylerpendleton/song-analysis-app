class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'open-uri'
  include Spotify

  before_action -> { UserAuth.all.each { |x| x.destroy if x.expired? } }

  private


  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

end
