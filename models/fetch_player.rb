class FetchPlayer
  def initialize(player)
    @player = player
  end

  def update
    update_service_record(:arena)
    update_service_record(:warzone)
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

  def warzone_json
    @_warzone_json ||= api_client.warzone_stats['WarzoneStat']
  end
end
