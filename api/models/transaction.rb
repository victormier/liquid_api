class Transaction < ActiveRecord::Base
  belongs_to :virtual_account

  scope :newest_first, -> { order('made_on desc, created_at desc') }
end
