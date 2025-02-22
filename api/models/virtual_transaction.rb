class VirtualTransaction < Transaction
  belongs_to :related_virtual_account, class_name: "VirtualAccount", foreign_key: "related_virtual_account_id"
  belongs_to :rule

  def description
    "Virtual transaction"
  end

  def category
    "virtual_transaction"
  end
end
