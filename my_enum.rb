# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    object = dup
    i = 0
    while i < length
      yield(object.shift)
      i += 1
    end
    self
  end
end
