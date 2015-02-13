class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    email: true
  validates :password, length: { minimum: 10, allow_blank: true }
end
