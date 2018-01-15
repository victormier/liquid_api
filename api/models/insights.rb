class Insights
  attr_reader :mirror_account, :start_date, :end_date

  def initialize(user, start_date, end_date)
    @user = user
    @start_date = start_date
    @end_date = end_date
    @mirror_account = @user.default_mirror_account
  end

  # Finds all monthly insight objects available for a user
  def self.all_monthly(user)
    return [] unless user.default_mirror_account.present?
    first_transaction = user.default_mirror_account.transactions.mirror.oldest_first.first
    return [] unless first_transaction

    start_date = Date.new(first_transaction.made_on.year, first_transaction.made_on.month, 1)
    today = Date.today
    insights = []

    while start_date.end_of_month <= today
      end_date = [Date.new(start_date.year, start_date.month, -1), today].min
      insights << self.new(user, start_date, end_date)
      start_date = start_date >> 1
    end
    insights.reverse
  end

  def income_transactions
    @income_transactions ||= @mirror_account.
                              transactions.
                              debit.
                              mirror.
                              from_date(@start_date).
                              to_date(@end_date).
                              order(amount: :desc)
  end

  def expense_transactions
    @expense_transactions ||= @mirror_account.
                                transactions.
                                credit.
                                mirror.
                                from_date(@start_date).
                                to_date(@end_date).
                                order(amount: :desc)
  end

  def total_income
    return 0.0 unless @mirror_account.present?
    income_transactions.sum(&:amount)
  end

  def total_expense
    return 0.0 unless @mirror_account.present?
    expense_transactions.sum(&:amount).abs
  end

  def total_balance
    @user.total_balance
  end

  def category_insights
    @category_insights ||= begin
      categories = []
      expense_transactions.group_by(&:category).each do |category, transactions|
        categories << CategoryInsight.new(category, transactions, total_expense)
      end
      categories.sort_by! { |c| c.amount }.reverse!
    end
  end

end
