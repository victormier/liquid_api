class Transaction < ActiveRecord::Base
  belongs_to :virtual_account

  scope :newest_first, -> { order('made_on desc, created_at desc') }
  scope :virtual, -> { where(type: 'VirtualTransaction') }
  scope :mirror, -> { where(type: 'MirrorTransaction') }
  scope :credit, -> { where("amount < 0.0") }
  scope :debit, -> { where("amount > 0.0") }
  scope :from_date, -> (date) { where("made_on >= ?", date) }
  scope :to_date, -> (date) { where("made_on <= ?", date) }
end
