class WeaponUsagesController < ApplicationController
  SELECT_SQL = <<-SQL
    weapons.image_url,
    weapons.name,
    weapons.weapon_type,
    weapon_usages.game_mode,
    weapon_usages.id,
    weapon_usages.kills,
    round(weapon_usages.kills::numeric / weapon_usages.time_used * 60, 2) as kpm
  SQL

  get '/weapon_usages' do
    player = Player.find(params[:player_id])
    weapons = player.weapon_usages.joins(:weapon)
      .select(SELECT_SQL)
      .where('weapon_usages.time_used > 60')
      .order(kpm: :desc)

    json(weapons)
  end
end
