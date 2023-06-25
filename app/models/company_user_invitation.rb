# typed: strict
require 'sorbet-runtime'

class CompanyUserInvitation < ApplicationRecord
  extend T::Sig

  belongs_to :company
  has_secure_token :token

  validates :user_email, presence: true, length: { maximum: 100 }, confirmation: true, uniqueness: { scope: :company }, format: { with: RegexUtil::EMAIL_REGEX }
  validates :user_email_confirmation, presence: true, if: Proc.new { |u| u.user_email_changed? }
  validates :token, uniqueness: true, allow_nil: true
end
