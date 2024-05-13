class PlayersController < ApplicationController
  get '/players/:id' do
    @player = Player.find(params[:id])
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
      emblem_url: client.emblem,
      gamertag: arena['PlayerId']['Gamertag'],
      refreshed_at: Time.current,
      spartan_rank: arena['SpartanRank']
    )
    content_type :json
    player.to_json
  end
end
