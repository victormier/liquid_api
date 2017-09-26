class VirtualAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :saltedge_account
  has_many :transactions
end
