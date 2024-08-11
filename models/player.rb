class Player < ActiveRecord::Base
  class PlayerNotFound < StandardError; end

  has_many :playlist_ranks, dependent: :destroy
  has_many :service_records, dependent: :destroy
  has_many :weapon_usages, dependent: :destroy

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
    raise(PlayerNotFound, 'Gamertag is blank') if gamertag.blank?
    player = find_by(slug: gamertag.parameterize)
    return player if player.present?

    emblem_url = ApiClient.new(gamertag.strip).emblem
    raise(PlayerNotFound, "Player not found: #{gamertag}") if emblem_url.blank?
    create(emblem_url:, gamertag:, spartan_rank: 1)
  end

  def profile_data
    as_json(only: %i[id emblem_url gamertag refreshed_at spartan_image_url spartan_rank]).merge(
      arena_record: service_records.arena.first&.profile_data,
      warzone_record: service_records.warzone.first&.profile_data
    )
  end

  def update_season_ranks(season, json = nil)
    json ||= ApiClient.new(gamertag).arena_stats(season.uid)

    json['ArenaStats']['ArenaPlaylistStats'].each do |attrs|
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
