require 'api/models/rule'

# When a credit (income) transaction reaches a certain amount,
# move a specific percentage of the amount to destination account.
class PercentageRule < Rule
  def default_config
    {
      minimum_amount: 0.0,
      percentage: 0
    }
  end

  def rule_applies?(transaction)
    transaction.amount >= config[:minimum_amount]
  end

  def apply_rule(transaction)
    if rule_applies?(transaction)
      # create automatic transaction
      amount = transaction.amount / 100.0 * config[:percentage]
      Services::CreateVirtualTransaction.new(user, {
        origin_account_id: user.default_mirror_account.id,
        destination_account_id: destination_virtual_account.id,
        amount: amount,
        rule_id: self.id
      }).call
    end
  end
end
