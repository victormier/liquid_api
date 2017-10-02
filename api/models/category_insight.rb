class CategoryInsight
  attr_reader :name, :transactions

  def initialize(name, transactions, total_income)
    @name = name
    @transactions = transactions
    @total_income = total_income
  end

  def amount
    @amount ||= transactions.sum(&:amount).abs
  end

  def percentage
    @percentage ||= (@amount / @total_income * 100.0).round
  end
end
