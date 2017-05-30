class Category < Sequel::Model
  many_to_one :post
end
