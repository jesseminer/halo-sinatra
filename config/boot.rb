require 'sinatra/base'
require 'dotenv/load' if Sinatra::Application.development?
require 'sinatra/activerecord'

require './models/api_client'
require './models/csr_tier'
require './models/fetch_player'
require './models/player'
require './models/playlist'
require './models/playlist_rank'
require './models/season'
require './models/service_record'
require './models/weapon_usage'
require './models/weapon'

require './controllers/application_controller'
require './controllers/players_controller'
require './controllers/playlist_ranks_controller'
require './controllers/weapon_usages_controller'
