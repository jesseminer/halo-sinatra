class ApplicationController < Sinatra::Base
  set(
    logging: true,
    root: './',
    server: :puma
  )

  get '/' do
    @recent_players = Player.order(created_at: :desc).limit(7)
    slim :home
  end
end
