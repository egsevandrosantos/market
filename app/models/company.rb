# typed: strict
require 'sorbet-runtime'

class Company < ApplicationRecord
  extend T::Sig

  has_many :users
  accepts_nested_attributes_for :users
  has_secure_token :token

  after_create_commit :after_create_commit

  validates :corporate_name, presence: true, length: { maximum: 100 }
  validates :fantasy_name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 100 }, confirmation: true, uniqueness: true, format: { with: RegexUtil::EMAIL_REGEX }
  validates :email_confirmation, presence: true, if: Proc.new { |c| c.email_changed? }
  validates :domain, presence: true, length: { maximum: 50 }, uniqueness: true, format: { with: RegexUtil::DOMAIN_REGEX }
  validates :cnpj, presence: true, length: { is: 14 }, numericality: { only_integer: true }, cnpj: true
  enum :status, StatusEnum::VALUES, prefix: true, default: :inactive
  validates :token, uniqueness: true, allow_nil: true

  private

  sig { void }
  def after_create_commit
    send_signin_email()
  end

  sig { void }
  def send_signin_email
    T.let(Api::V1::CompaniesMailer, T.untyped).with(company: self).signup.deliver_later
  end
end
