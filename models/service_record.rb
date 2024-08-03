class ServiceRecord < ActiveRecord::Base
  enum game_mode: { arena: 0, warzone: 1 }

  belongs_to :player

  validates :player_id, uniqueness: { scope: :game_mode }

  def kd_ratio = deaths == 0 ? kills : kills.to_f / deaths

  def win_percentage = games_played == 0 ? 0 : games_won.to_f / games_played * 100
end
