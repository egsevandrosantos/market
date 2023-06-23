# typed: strict
require 'sorbet-runtime'

class StatusEnum
  extend T::Sig

  VALUES = T.let({ inactive: 1, active: 2 }.freeze, T::Hash[Symbol, Integer])
end