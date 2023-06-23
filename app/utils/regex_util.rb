# typed: strict
require 'sorbet-runtime'

class RegexUtil
  extend T::Sig

  EMAIL_REGEX = T.let(/\A[a-zA-Z0-9_!#$%&'*+\/=?`{|}~^.-]+@[a-zA-Z0-9.-]+\z/, Regexp)
  DOMAIN_REGEX = T.let(/\A[a-zA-Z]([a-zA-Z0-9]+[.-]?)+\z/, Regexp)
end