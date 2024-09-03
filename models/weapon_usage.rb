class WeaponUsage < ActiveRecord::Base
  enum game_mode: { arena: 0, warzone: 1 }

  belongs_to :player
  belongs_to :weapon

  validates :player_id, uniqueness: { scope: [:weapon_id, :game_mode] }
end
