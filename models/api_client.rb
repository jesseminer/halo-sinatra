require 'net/http'

class ApiClient
  def initialize(gamertag)
    @gamertag = gamertag
  end

  def self.get(path, params = {})
    JSON.parse(raw_response(path, params).body)
  end

  def self.parse_duration(d)
    days = d.match(/(\d+)D/).try(:[], 1).to_i
    hours = d.match(/(\d+)H/).try(:[], 1).to_i
    minutes = d.match(/(\d+)M/).try(:[], 1).to_i
    seconds = d.match(/(\d+)(\.\d+)?S/).try(:[], 1).to_i

    days * 86400 + hours * 3600 + minutes * 60 + seconds
  end

  def self.raw_response(path, params = {})
    uri = URI("https://www.haloapi.com/#{path}")
    uri.query = URI.encode_www_form(params)
    req = Net::HTTP::Get.new(uri)
    req['Ocp-Apim-Subscription-Key'] = ENV.fetch('HALO_API_KEY')
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  end

  def arena_stats(season_uid = nil)
    json = self.class.get('stats/h5/servicerecords/arena', players: @gamertag, seasonId: season_uid)
    json['Results'][0]['Result']
  end

  def emblem
    self.class.raw_response("profile/h5/profiles/#{ERB::Util.url_encode(@gamertag)}/emblem")['location']
  end

  def spartan_image
    self.class.raw_response("profile/h5/profiles/#{ERB::Util.url_encode(@gamertag)}/spartan")['location']
  end

  def warzone_stats
    self.class.get('stats/h5/servicerecords/warzone', players: @gamertag)['Results'][0]['Result']
  end
end
