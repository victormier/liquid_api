class SaltedgeAccount < ActiveRecord::Base
  ACCOUNT_NATURE_WHITELIST = %w(account checking)

  belongs_to :saltedge_login
  belongs_to :user
  has_many :saltedge_transactions, dependent: :destroy

  serialize :saltedge_data, Hash

  def type
    "saltedge"
  end

  def transactions
    saltedge_transactions
  end

  def currency_code
    saltedge_data["currency_code"]
  end

  def balance
    saltedge_data["balance"] || 0.0
  end

  def name
    saltedge_data["name"] || "Account"
  end
end
