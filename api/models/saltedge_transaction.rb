class SaltedgeTransaction < ActiveRecord::Base
  belongs_to :saltedge_account
  serialize :saltedge_data, Hash
  has_one :mirror_transaction

  scope :newest_first, -> { order('made_on desc, saltedge_created_at desc') }
  scope :saltedge_id_ordered, -> { order('saltedge_id desc') }

  def type
    "saltedge"
  end

  def description
    saltedge_data["description"]
  end
end
