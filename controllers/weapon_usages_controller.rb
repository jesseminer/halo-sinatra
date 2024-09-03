class WeaponUsagesController < ApplicationController
  get '/weapon_usages' do
    player = Player.find(params[:player_id])
    weapons = player.weapon_usages.joins(:weapon).order(:name).preload(:weapon).map { |wu| weapon_hash(wu) }
    json(weapons)
  end

  private

  def weapon_hash(wu)
    {
      id: wu.id,
      game_mode: wu.game_mode,
      image_url: wu.weapon.image_url,
      kills: wu.kills,
      kpm: wu.kpm,
      name: wu.weapon.name
    }
  end
end
