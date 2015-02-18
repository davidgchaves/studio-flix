class User < ActiveRecord::Base
  has_secure_password

  validates_presence_of :name
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    email: true
  validates :password, length: { minimum: 10, allow_blank: true }
end
