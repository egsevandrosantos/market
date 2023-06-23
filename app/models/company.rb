# typed: strict
require 'sorbet-runtime'

class Company < ApplicationRecord
  has_secure_token :token

  validates :corporate_name, presence: true, length: { maximum: 100 }
  validates :fantasy_name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 100 }, confirmation: true, uniqueness: true, format: { with: RegexUtil::EMAIL_REGEX }
  validates :email_confirmation, presence: true, if: Proc.new { |c| c.email_changed? }
  validates :domain, presence: true, length: { maximum: 50 }, uniqueness: true, format: { with: RegexUtil::DOMAIN_REGEX }
  validates :cnpj, presence: true, length: { is: 14 }, numericality: { only_integer: true }, cnpj: true
  enum :status, StatusEnum::VALUES, prefix: true, default: :inactive
  validates :token, uniqueness: true, allow_nil: true
end
