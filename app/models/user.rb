class User < ApplicationRecord
  belongs_to :company
  has_secure_token :token
  has_secure_password
end
