class SaltedgeTransaction < ActiveRecord::Base
  belongs_to :saltedge_account
  serialize :saltedge_data, Hash

  scope :newest_first, -> { order('made_on desc, saltedge_created_at desc') }
end
