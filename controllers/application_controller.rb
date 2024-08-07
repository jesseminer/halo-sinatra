class ApplicationController < Sinatra::Base
  include ActiveSupport::NumberHelper

  set(
    logging: true,
    root: './',
    server: :puma
  )

  get '/' do
    @recent_players = Player.order(created_at: :desc).limit(7)
    slim :home
  end

  private

  def json(data)
    content_type :json
    data.to_json
  end
end
