class VirtualAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :saltedge_account
  has_many :transactions

  scope :mirror, -> { where("saltedge_account_id IS NOT NULL") }

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

  def last_updated
    return nil unless is_mirror_account
    saltedge_account.last_updated
  end

  def is_refreshing
    return false unless is_mirror_account
    saltedge_account.is_refreshing
  end
end
