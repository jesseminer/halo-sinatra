class Playlist < ActiveRecord::Base
  enum game_mode: %i[arena warzone campaign custom]

  validates :uid, presence: true, uniqueness: true

  def self.refresh_from_halo_api
    ApiClient.get('metadata/h5/metadata/playlists').each do |attrs|
      find_or_initialize_by(uid: attrs['id']).update!(
        name: attrs['name'],
        description: attrs['description'],
        game_mode: attrs['gameMode'].downcase,
        active: attrs['isActive'],
        ranked: attrs['isRanked']
      )
    end
  end
end
