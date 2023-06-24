# typed: strict
require 'sorbet-runtime'

class CnpjValidator < ActiveModel::EachValidator
  extend T::Sig

  sig { params(cnpj: T.nilable(String)).returns(T::Boolean) }
  def self.valid?(cnpj)
    if cnpj.present? && cnpj.length == 14 && cnpj.match?(/\A[0-9]{14}\z/) && !cnpj.match?(/\A(.)\1*\z/)
      dv1 = T.let(calc_dv([5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2], cnpj), Integer)
      dv2 = T.let(calc_dv([6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2], cnpj), Integer)
      return true if cnpj.end_with?("#{dv1}#{dv2}")
    end
    return false
  end

  sig { params(record: ApplicationRecord, attribute: Symbol, value: T.nilable(String)).void }
  def validate_each(record, attribute, value)
    if !CnpjValidator.valid?(value)
      record.errors.add(attribute, I18n.t(options[:message] || "activerecord.errors.messages.invalid"))
    end
  end

  private

  sig { params(to_mult: T::Array[Integer], cnpj: String ).returns(Integer) }
  def self.calc_dv(to_mult, cnpj)
    mult = T.let([], T::Array[Integer])
    to_mult.each_with_index do |val, index|
      mult.push(val * cnpj[index].to_i)
    end
    sum = T.let(mult.reduce(:+), Integer)
    remainder = T.let(sum % 11, Integer)
    return T.let(remainder < 2 ? 0 : 11 - remainder, Integer)
  end
end