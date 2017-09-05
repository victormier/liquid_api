require 'spec_helper'

RSpec.describe SaltedgeProviderType do
  let(:required_fields) do
    [
      {
        "name"=>"login",
        "english_name"=>"Client number",
        "localized_name"=>"Klientské číslo",
        "nature"=>"text",
        "optional"=>false,
        "position"=>1
      },
      {
        "name"=>"password",
        "english_name"=>"Password",
        "localized_name"=>"Heslo",
        "nature"=>"password",
        "optional"=>false,
        "position"=>2
      }
    ]
  end
  let(:saltedge_provider) do
    SaltedgeProvider.create(
      name: "Fake Bank",
      country_code: "CZ",
      status: "active",
      mode: "web",
      automatic_fetch: true,
      saltedge_data: {
        "required_fields" => required_fields
      }
    )
  end

  subject {
    Schema.types["SaltedgeProvider"]
  }

  describe "#fields_description" do
    it "#resolve returns an array of hashes with required_fields" do
      required_fields_field = subject.fields["required_fields"]
      result = required_fields_field.resolve(saltedge_provider, nil, nil)
      expect(result).to eq(required_fields)
    end
  end

end
