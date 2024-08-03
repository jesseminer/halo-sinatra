class PlaylistRank < ActiveRecord::Base
  belongs_to :csr_tier
  belongs_to :player
  belongs_to :playlist
  belongs_to :season

  validates :player_id, uniqueness: { scope: [:playlist_id, :season_id] }

  scope :highest_first, -> {
    joins(:csr_tier)
      .order('csr_tiers.identifier desc, playlist_ranks.progress_percent desc, playlist_ranks.csr desc')
  }
end
