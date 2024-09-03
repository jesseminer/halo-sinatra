class WeaponUsage < ActiveRecord::Base
  enum game_mode: { arena: 0, warzone: 1 }

  belongs_to :player
  belongs_to :weapon

  validates :player_id, uniqueness: { scope: [:weapon_id, :game_mode] }

  def kpm
    time_used == 0 ? 0 : (60 * kills.to_f / time_used).round(2)
  end
end
