class Company < ApplicationRecord
  has_secure_token :token
end
