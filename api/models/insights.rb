class Insights
  attr_reader :mirror_account

  def initialize(user, start_date, end_date)
    @user = user
    @start_date = start_date
    @end_date = end_date
    @mirror_account = @user.default_mirror_account
  end

  def income_transactions
    @income_transactions ||= @mirror_account.
                              transactions.
                              debit.
                              from_date(@start_date).
                              to_date(@end_date).
                              order(amount: :desc)
  end

  def expense_transactions
    @expense_transactions ||= @mirror_account.
                                transactions.
                                credit.
                                from_date(@start_date).
                                to_date(@end_date).
                                order(amount: :desc)
  end

  def total_income
    income_transactions.sum(&:amount)
  end

  def total_expense
    expense_transactions.sum(&:amount).abs
  end

  def category_insights
    @category_insights ||= begin
      categories = []
      expense_transactions.group_by(&:category).each do |category, transactions|
        categories << CategoryInsight.new(category, transactions, total_expense)
      end
      categories
    end
  end

  def total_expenses
    0.0
  end
end
