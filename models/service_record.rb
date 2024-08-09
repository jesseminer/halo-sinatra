class ServiceRecord < ActiveRecord::Base
  include ActiveSupport::NumberHelper

  enum game_mode: { arena: 0, warzone: 1 }

  belongs_to :player

  validates :player_id, uniqueness: { scope: :game_mode }

  def kd_ratio = deaths == 0 ? kills : (kills.to_f / deaths).round(2)

  def profile_data
    {
      game_mode: game_mode.titlecase,
      games_played: number_to_delimited(games_played),
      kd_ratio:,
      win_percentage:
    }
  end

  def win_percentage = games_played == 0 ? 0 : (games_won.to_f / games_played * 100).round(1)
end
