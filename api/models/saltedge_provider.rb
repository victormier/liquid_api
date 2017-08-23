class SaltedgeProvider < ActiveRecord::Base
  serialize :saltedge_data, Hash
end
