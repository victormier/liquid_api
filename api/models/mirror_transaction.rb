require 'api/models/transaction'

# Represent a mirror of a real transaction
class MirrorTransaction < Transaction
  belongs_to :saltedge_transaction
end
