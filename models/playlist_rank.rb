class PlaylistRank < ActiveRecord::Base
  belongs_to :csr_tier
  belongs_to :player
  belongs_to :playlist
  belongs_to :season
end
