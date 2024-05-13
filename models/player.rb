class Player < ActiveRecord::Base
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
      gamertag: gamertag,
      spartan_image_url: ApiClient.new(gamertag.strip).spartan_image,
      spartan_rank: 1
    )
  end
end
