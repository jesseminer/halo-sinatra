class ApplicationController < Sinatra::Base
  set(
    logging: true,
    root: './',
    server: :puma
  )

  get '/' do
    render_home
  end

  private

  def json(data)
    content_type :json
    data.to_json
  end

  def render_home(locals = {})
    @recent_players = Player.order(created_at: :desc).limit(7)
    slim :home, locals:
  end
end
