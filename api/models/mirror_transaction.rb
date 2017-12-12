require_relative 'transaction'

# Represent a mirror of a real transaction
class MirrorTransaction < Transaction
  belongs_to :saltedge_transaction

  delegate :description, to: :saltedge_transaction

  def category
    custom_category || saltedge_transaction.category
  end
end
