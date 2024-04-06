class PlayersController < ApplicationController
  get '/players/:id' do
    slim :'players/show'
  end
end
