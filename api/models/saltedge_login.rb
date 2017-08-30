class SaltedgeLogin < ActiveRecord::Base
  belongs_to :user
  belongs_to :saltedge_provider

  serialize :saltedge_data, Hash
end
