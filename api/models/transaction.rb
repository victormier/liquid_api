class Transaction < ActiveRecord::Base
  belongs_to :virtual_account

  scope :newest_first, -> { order('transactions.made_on desc, transactions.saltedge_id asc') }
  scope :oldest_first, -> { order('transactions.made_on asc, transactions.created_at asc') }
  scope :virtual, -> { where("transactions.type" => 'VirtualTransaction') }
  scope :mirror, -> { where("transactions.type" => 'MirrorTransaction') }
  scope :credit, -> { where("transactions.amount < 0.0") }
  scope :debit, -> { where("transactions.amount > 0.0") }
  scope :from_date, -> (date) { where("transactions.made_on >= ?", date) }
  scope :to_date, -> (date) { where("transactions.made_on <= ?", date) }
  scope :automatic, -> { where('transactions.rule_id IS NOT NULL') }

  def category_name
    category.humanize
  end
end
