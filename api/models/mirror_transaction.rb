require_relative 'transaction'

# Represent a mirror of a real transaction
class MirrorTransaction < Transaction
  belongs_to :saltedge_transaction

  delegate :description, :category, to: :saltedge_transaction
end
