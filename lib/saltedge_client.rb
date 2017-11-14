class SaltedgeClient
  attr_reader :client_id, :service_secret, :private_pem_path

  EXPIRATION_TIME = 60
  BASE_URL = "https://www.saltedge.com/api/v3"

  def initialize
    @client_id          = ENV["SALTEDGE_CLIENT_ID"]
    @service_secret     = ENV["SALTEDGE_SERVICE_SECRET"]
  end

  def request(method, path, params={})
    hash = {
      method:     method,
      url:        BASE_URL + path,
      expires_at: (Time.now + EXPIRATION_TIME).to_i,
      params:     params.to_json
    }

    RestClient::Request.execute(
      method:  hash[:method],
      url:     hash[:url],
      payload: hash[:params],
      headers: {
        "Accept"         => "application/json",
        "Content-type"   => "application/json",
        "Expires-at"     => hash[:expires_at],
        "Client-id"      => client_id,
        "Service-secret" => service_secret,
        "Signature"      => signature(hash)
      }
    )
  end

private

  def signature(hash)
    Base64.encode64(rsa_key.sign(digest, "#{hash[:expires_at]}|#{hash[:method].to_s.upcase}|#{hash[:url]}|#{hash[:params]}")).delete("\n")
  end

  def rsa_key
    @rsa_key ||= begin
      private_key = ENV["RACK_ENV"] == "production" ? ENV["RSA_PRIVATE_KEY"] : File.open('config/private-staging.pem')
      OpenSSL::PKey::RSA.new(private_key)
    end
  end

  def digest
    OpenSSL::Digest::SHA1.new
  end

  def as_json(params)
    return "" if params.empty?
    params.to_json
  end
end
