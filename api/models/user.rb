class User < ActiveRecord::Base
  has_secure_password

  has_many :comments
  has_many :posts

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_presence_of :password_digest
end
