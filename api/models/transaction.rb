class Transaction < ActiveRecord::Base
  belongs_to :virtual_account
end
