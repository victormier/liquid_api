module Services
  class RemoveDuplicateTransactions
    def call
      grouped_transactions = SaltedgeTransaction.all.group_by{|st| [st.saltedge_account_id, st.saltedge_id]}
      grouped_transactions.values.each do |duplicated_transactions|
        first_one = duplicated_transactions.shift
        duplicated_transactions.each{ |dt| dt.destroy }
      end

      VirtualAccount.mirror.each { |va| va.compute_balance! }
    end
  end
end
