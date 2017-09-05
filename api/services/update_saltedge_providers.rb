module Services
  class UpdateSaltedgeProviders
    STOREABLE_ATTRIBUTES = %w(saltedge_id saltedge_data name status mode automatic_fetch country_code)

    def initialize(page = nil)
      @saltedge_client = SaltedgeClient.new
    end

    def call
      providers_data, next_id = retrieve_providers
      while next_id do
        store_providers(providers_data)
        providers_data, next_id = retrieve_providers(next_id)
      end
    end

    private

    def retrieve_providers(from_id = nil)
      params = {
        include_provider_fields: true
      }
      params[:include_fake_providers] = true if LiquidApi.development?
      params[:from_id] = from_id unless from_id.nil?
      response = @saltedge_client.request(:get, "/providers", params)
      parsed_response = JSON.parse(response.body)

      [parsed_response["data"], parsed_response["meta"]["next_id"]]
    end

    def store_providers(providers_hash)
      providers_hash.each do |provider_data|
        saltedge_provider = SaltedgeProvider.find_or_initialize_by(saltedge_id: provider_data["id"])
        attrs = provider_data.select {|k,v| STOREABLE_ATTRIBUTES.include?(k) }
        saltedge_provider.assign_attributes(attrs)
        saltedge_provider.saltedge_data = provider_data
        saltedge_provider.save if saltedge_provider.changed?
      end
    end
  end
end
