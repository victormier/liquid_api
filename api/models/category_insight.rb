class CategoryInsight
  attr_reader :code, :transactions

  def initialize(code, transactions, total_income)
    @code = code
    @transactions = transactions
    @total_income = total_income
  end

  def amount
    @amount ||= transactions.sum(&:amount).abs
  end

  def percentage
    @percentage ||= (@amount / @total_income * 100.0).round
  end

  def name
    @code.humanize
  end
end
