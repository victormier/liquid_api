class SaltedgeAccount < ActiveRecord::Base
  ACCOUNT_NATURE_WHITELIST = %w(account checking)

  belongs_to :saltedge_login
  belongs_to :user

  serialize :saltedge_data, Hash
end
