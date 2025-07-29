class User < ApplicationRecord
  has_many :books
  has_secure_password
  validates :username, :email, presence: true, uniqueness: { case_sensitive: false }
end
