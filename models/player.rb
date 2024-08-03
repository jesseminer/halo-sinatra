class Player < ActiveRecord::Base
  has_many :playlist_ranks
  has_many :service_records

  validates :gamertag, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation do
    gamertag.strip!
    self.slug = gamertag.parameterize
  end

  def self.find(id_or_slug)
    id_or_slug.to_s.match(/^\d+$/) ? find_by!(id: id_or_slug) : find_by!(slug: id_or_slug)
  end

  def self.find_or_create(gamertag)
    fail(RuntimeError, 'Gamertag is blank') if gamertag.blank?

    find_by(slug: gamertag.parameterize) || create(
      emblem_url: ApiClient.new(gamertag.strip).emblem,
      gamertag: gamertag,
      spartan_rank: 1
    )
  end

  def update_season_ranks(season, json = nil)
    json ||= ApiClient.new(gamertag).arena_stats(season.uid)['ArenaStats']['ArenaPlaylistStats']

    json.each do |attrs|
      csr_attrs = attrs['Csr']
      next if csr_attrs.blank?

      playlist = Playlist.find_by(uid: attrs['PlaylistId'])
      playlist_ranks.find_or_initialize_by(season:, playlist:).update!(
        csr_tier: CsrTier.find_by(identifier: "#{csr_attrs['DesignationId']}-#{csr_attrs['Tier']}"),
        progress_percent: csr_attrs['PercentToNextTier'],
        csr: csr_attrs['Csr'],
        rank: csr_attrs['Rank']
      )
    end

    if season.end_time&.past? && !completed_seasons.include?(season.id.to_s)
      completed_seasons << season.id
      save
    end
  end
end
