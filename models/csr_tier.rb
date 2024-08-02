class CsrTier < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: true

  def self.refresh_from_halo_api
    ApiClient.get('metadata/h5/metadata/csr-designations').each do |attrs|
      designation = attrs['name']

      attrs['tiers'].each do |tier|
        identifier = "#{attrs['id']}-#{tier['id']}"
        name = %w[Unranked Onyx Champion].include?(designation) ?
          designation :
          "#{designation} #{tier['id']}"

        find_or_initialize_by(identifier:).update!(
          identifier:,
          name:,
          image_url: tier['iconImageUrl']
        )
      end
    end
  end
end
