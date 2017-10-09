class Rule < ActiveRecord::Base
  belongs_to :user
  belongs_to :destination_virtual_account, class_name: "VirtualAccount", foreign_key: "virtual_account_id"
  has_many :transactions

  serialize :config, Hash

  def default_config
    {}
  end

  def rule_applies?
    false
  end

  def apply_rule
    nil
  end
end
