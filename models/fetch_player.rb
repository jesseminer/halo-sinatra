class FetchPlayer
  def initialize(player)
    @player = player
  end

  def update
    update_service_record(:arena)
    update_service_record(:warzone)
    update_weapon_stats(:arena)
    update_weapon_stats(:warzone)
    update_current_season_ranks
    update_profile_info
  end

  private

  def api_client
    @_api_client ||= ApiClient.new(@player.gamertag)
  end

  def arena_json
    @_arena_json ||= api_client.arena_stats
  end

  def service_record_fields(json)
    {
      kills: json['TotalSpartanKills'],
      assists: json['TotalAssists'],
      deaths: json['TotalDeaths'],
      games_played: json['TotalGamesCompleted'],
      games_won: json['TotalGamesWon'],
      time_played: ApiClient.parse_duration(json['TotalTimePlayed'])
    }
  end

  def update_current_season_ranks
    @player.update_season_ranks(Season.current, arena_json)
  end

  def update_profile_info
    @player.update!(
      gamertag: arena_json['PlayerId']['Gamertag'],
      spartan_rank: arena_json['SpartanRank'],
      spartan_image_url: api_client.spartan_image,
      emblem_url: api_client.emblem,
      refreshed_at: Time.current
    )
  end

  def update_service_record(game_mode)
    json = game_mode == :arena ? arena_json['ArenaStats'] : warzone_json
    @player.service_records.find_or_initialize_by(game_mode:).update!(service_record_fields(json))
  end

  def update_weapon_stats(game_mode)
    json = game_mode == :arena ? arena_json['ArenaStats'] : warzone_json
    weapon_usages = @player.weapon_usages.public_send(game_mode)

    json['WeaponStats'].each do |data|
      weapon = Weapon.find_by(uid: data['WeaponId']['StockId'])
      next if weapon.nil?

      weapon_usages.find_or_initialize_by(weapon:).update!(
        kills: data['TotalKills'],
        headshots: data['TotalHeadshots'],
        damage_dealt: data['TotalDamageDealt'].to_f.round,
        shots_fired: data['TotalShotsFired'],
        shots_hit: data['TotalShotsLanded'],
        time_used: ApiClient.parse_duration(data['TotalPossessionTime'])
      )
    end
  end

  def warzone_json
    @_warzone_json ||= api_client.warzone_stats['WarzoneStat']
  end
end
