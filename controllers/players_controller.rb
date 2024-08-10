class PlayersController < ApplicationController
  get '/players' do
    render_home
  end

  get '/players/:id' do
    @player = Player.find(params[:id])
    @seasons = Season.order(start_time: :desc)
    slim :'players/show'
  end

  post '/players' do
    player = Player.find_or_create(params[:gamertag])
    redirect to("/players/#{player.slug}")
  rescue Player::PlayerNotFound => e
    render_home(error_msg: e.message)
  end

  put '/players/:id/fetch' do
    player = Player.find(params[:id])
    FetchPlayer.new(player).update
    json(player.profile_data)
  end
end
