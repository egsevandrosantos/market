# typed: strict
require 'sorbet-runtime'

class CpfValidator < ActiveModel::EachValidator
  extend T::Sig

  sig { params(cpf: T.nilable(String)).returns(T::Boolean) }
  def self.valid?(cpf)
    if cpf.present? && cpf.length == 11 && cpf.match?(/\A[0-9]{11}\z/) && !cpf.match?(/\A(.)\1*\z/)
      dv1 = T.let(calc_dv([10, 9, 8, 7, 6, 5, 4, 3, 2], cpf), Integer)
      dv2 = T.let(calc_dv([11, 10, 9, 8, 7, 6, 5, 4, 3, 2], cpf), Integer)
      return true if cpf.end_with?("#{dv1}#{dv2}")
    end
    return false
  end

  sig { params(record: ApplicationRecord, attribute: Symbol, value: T.nilable(String)).void }
  def validate_each(record, attribute, value)
    if !CpfValidator.valid?(value)
      record.errors.add(attribute, I18n.t(options[:message] || "activerecord.errors.messages.invalid"))
    end
  end

  private
  
  sig { params(to_mult: T::Array[Integer], value: String).returns(Integer) }
  def self.calc_dv(to_mult, value)
    mult = T.let([], T::Array[Integer])
    to_mult.each_with_index do |val, index|
      mult.push(val * value[index].to_i)
    end
    sum = T.let(mult.reduce(:+), Integer)
    remainder = T.let(sum % 11, Integer)
    return T.let(remainder < 2 ? 0 : 11 - remainder, Integer)
  end
end