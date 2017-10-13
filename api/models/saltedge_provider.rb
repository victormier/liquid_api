class SaltedgeProvider < ActiveRecord::Base
  serialize :saltedge_data, Hash

  scope :automatically_fetchable, -> { where(automatic_fetch: true) }
end
