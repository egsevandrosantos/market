# typed: strict
require 'sorbet-runtime'

class RegexUtil
  extend T::Sig

  EMAIL_REGEX = T.let(/\A[a-zA-Z0-9_!#$%&'*+\/=?`{|}~^.-]+@[a-zA-Z0-9.-]+\z/, Regexp)
  DOMAIN_REGEX = T.let(/\A[a-zA-Z]([a-zA-Z0-9]+[.-]?)+\z/, Regexp)
  PASSWORD_REGEX = T.let(/\A(?=.*[a-z].*[a-z])(?=.*[A-Z].*[A-Z])(?=.*\d.*\d)(?=.*[^a-zA-Z0-9].*[^a-zA-Z0-9]).{8,20}\z/, Regexp)
end