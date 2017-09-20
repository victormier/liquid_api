class SaltedgeLogin < ActiveRecord::Base
  belongs_to :user
  belongs_to :saltedge_provider
  has_many :saltedge_accounts, dependent: :destroy

  serialize :saltedge_data, Hash

  def active
    saltedge_data["status"] == "active"
  end

  def finished_connecting
    saltedge_data["status"] == "active" ||
    (saltedge_data["last_attempt"] && saltedge_data["last_attempt"]["finished"])
  end
end
