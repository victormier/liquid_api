class VirtualAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :saltedge_account
  has_many :transactions

  def compute_balance!
    if is_mirror_account
      self.balance = saltedge_account.balance + transactions.virtual.sum(&:amount)
    else
      self.balance = transactions.virtual.sum(&:amount)
    end
    save!
  end

  def is_mirror_account
    !saltedge_account.nil?
  end
end
