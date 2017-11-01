module Services
  class CopySaltedgeIdsToMirrorTransactions
    def call
      MirrorTransaction.all.each do |mirror_transaction|
        mirror_transaction.update_attributes(saltedge_id: mirror_transaction.saltedge_transaction.saltedge_id)
      end
    end
  end
end
