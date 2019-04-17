class Team < ApplicationRecord
  has_secure_password
  has_many :members
end
