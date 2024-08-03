class ServiceRecord < ActiveRecord::Base
  enum game_mode: { arena: 0, warzone: 1 }

  belongs_to :player

  validates :player_id, uniqueness: { scope: :game_mode }
end
