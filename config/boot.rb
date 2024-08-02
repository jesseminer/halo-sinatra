require 'dotenv/load'
require 'sinatra/base'
require 'sinatra/activerecord'

require './models/api_client'
require './models/csr_tier'
require './models/player'
require './models/playlist'
require './models/playlist_rank'
require './models/season'

require './controllers/application_controller'
require './controllers/players_controller'
