class VirtualTransaction < Transaction
  belongs_to :related_virtual_account, class_name: "VirtualAccount", foreign_key: "related_virtual_account_id"
end
