SaltedgeProviderType = GraphQL::ObjectType.define do
  name "SaltedgeProvider"
  description "A saltedge provider for account connection"

  field :id, !types.ID
  field :name, !types.String
  field :country_code, !types.String
  field :instruction, !types.String
  field :required_fields, types[SaltedgeProviderFieldDescriptionType] do
    resolve -> (obj, args, _ctx) do
      obj.saltedge_data['required_fields']
    end
  end
end

SaltedgeProviderFieldDescriptionType = GraphQL::ObjectType.define do
  name "SaltedgeProviderFieldDescriptionType"
  description "Input field description for saltedge provider specific fields"

  field :id, !types.ID do
    resolve -> (obj, args, _ctx) do
      "#{obj["name"]}_#{obj["position"]}"
    end
  end
  field :nature, !types.String, hash_key: 'nature'
  field :name, !types.String, hash_key: 'name'
  field :position, types.Int, hash_key: 'position'
  field :localized_name, types.String, hash_key: 'localized_name'
  field :optional, types.Boolean, hash_key: 'optional'
  field :field_options, types[SaltedgeFieldOptionsType] do
    resolve -> (obj, args, _ctx) do
      obj["field_options"]
    end
  end
end

SaltedgeFieldOptionsType = GraphQL::ObjectType.define do
  name "SaltedgeFieldOptionsType"
  description "Options for select fields in saltedge provider specific fields"

  field :id, !types.ID do
    resolve -> (obj, args, _ctx) do
      "#{obj["name"]}_#{obj["option_value"]}"
    end
  end
  field :name, !types.String, hash_key: 'name'
  field :english_name, types.String, hash_key: 'english_name'
  field :localized_name, types.String, hash_key: 'localized_name'
  field :option_value, !types.String, hash_key: 'option_value'
  field :selected, types.Boolean, hash_key: 'selected'
end
