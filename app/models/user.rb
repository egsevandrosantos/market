# typed: strict
require 'sorbet-runtime'

class User < ApplicationRecord
  extend T::Sig
  belongs_to :company
  has_secure_token :token
  has_secure_password

  after_create_commit :after_create_commit

  validates :full_name, presence: true, length: { maximum: 100 }
  validates :cpf, presence: true, length: { is: 11 }, numericality: { only_integer: true }, uniqueness: { scope: :company }, cpf: true
  validates :email, presence: true, length: { maximum: 100 }, confirmation: true, uniqueness: { scope: :company }, format: { with: RegexUtil::EMAIL_REGEX }
  validates :email_confirmation, presence: true, if: Proc.new { |u| u.email_changed? }
  validates :password, presence: true, length: { in: 8..20 }, confirmation: true, format: { with: RegexUtil::PASSWORD_REGEX }, if: Proc.new { |u| u.password_digest_changed? }
  validates :password_confirmation, presence: true, if: Proc.new { |u| u.password_digest_changed? }
  enum :status, StatusEnum::VALUES, prefix: true, default: :inactive
  validates :token, uniqueness: true, allow_nil: true

  private

  sig { void }
  def after_create_commit
    send_signin_email()
  end

  sig { void }
  def send_signin_email
    T.let(Api::V1::UsersMailer, T.untyped).with(user: self).signup.deliver_later
  end
end
