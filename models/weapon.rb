class Weapon < ActiveRecord::Base
  validates :uid, presence: true, uniqueness: true

  def self.refresh_from_halo_api
    ApiClient.get('metadata/h5/metadata/weapons').each do |attrs|
      find_or_initialize_by(uid: attrs['id']).update!(
        name: attrs['name'],
        weapon_type: attrs['type'],
        description: attrs['description'],
        image_url: attrs['smallIconImageUrl'],
        usable_by_player: attrs['isUsableByPlayer']
      )
    end
  end
end
