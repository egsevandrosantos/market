# typed: strict
require 'sorbet-runtime'

class User < ApplicationRecord
  belongs_to :company
  has_secure_token :token
  has_secure_password

  validates :full_name, presence: true, length: { maximum: 100 }
  validates :cpf, presence: true, length: { is: 11 }, numericality: { only_integer: true }, uniqueness: { scope: :company }, cpf: true
  validates :email, presence: true, length: { maximum: 100 }, confirmation: true, uniqueness: { scope: :company }, format: { with: RegexUtil::EMAIL_REGEX }
  validates :email_confirmation, presence: true, if: Proc.new { |u| u.email_changed? }
  validates :password, length: { in: 8..20 }, confirmation: true, format: { with: RegexUtil::PASSWORD_REGEX }
  validates :password_confirmation, presence: true, if: Proc.new { |u| u.password_digest_changed? }
  enum :status, StatusEnum::VALUES, prefix: true, default: :inactive
  validates :token, uniqueness: true, allow_nil: true
end
