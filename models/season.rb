class Season < ActiveRecord::Base
  validates :uid, presence: true, uniqueness: true

  def self.current = order(:start_time).last

  def self.refresh_from_halo_api
    ApiClient.get('metadata/h5/metadata/seasons').each do |attrs|
      find_or_initialize_by(uid: attrs['id']).update!(
        name: attrs['name'],
        start_time: attrs['startDate'],
        end_time: attrs['endDate']
      )
    end
  end
end
