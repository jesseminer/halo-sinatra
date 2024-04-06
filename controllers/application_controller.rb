class ApplicationController < Sinatra::Base
  set :root, './'

  get '/' do
    slim :home
  end
end
