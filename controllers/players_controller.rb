class PlayersController < ApplicationController
  get '/players/:id' do
    @player = Player.find(params[:id])
    @seasons = Season.order(start_time: :desc)
    slim :'players/show'
  end

  post '/players' do
    player = Player.find_or_create(params[:gamertag])
    redirect to("/players/#{player.slug}")
  end

  put '/players/:id/fetch' do
    player = Player.find(params[:id])
    client = ApiClient.new(player.gamertag)
    arena = client.arena_stats
    player.update(
      gamertag: arena['PlayerId']['Gamertag'],
      refreshed_at: Time.current,
      spartan_image_url: client.spartan_image,
      spartan_rank: arena['SpartanRank']
    )
    json(player)
  end
end
