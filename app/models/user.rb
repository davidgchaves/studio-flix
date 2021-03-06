class User < ActiveRecord::Base
  has_secure_password

  validates_presence_of :name
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    email: true
  validates_length_of :password, minimum: 10
end
