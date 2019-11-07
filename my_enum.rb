# frozen_string_literal: true

module Enumerable
  class Hash
    def <<(hash)
      self[hash[0]] = hash[1]
    end
  end
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

  def my_map
    return to_enum unless block_given?

    copy_arr = dup
    new_object = self.class.new
    0.upto(length - 1) do
      result = yield(copy_arr.shift)
      if result.is_a? Array
        new_object[result[0]] = result[1]
      else
        new_object.push result
      end
    end
    new_object
  end

  def my_each_with_index
    return to_enum unless block_given?

    object = dup
    i = 0
    while i < length
      yield(object.shift, i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    new_object = dup
    result = self.class.new
    new_object.my_each do |item|
      result << item if yield(item)
    end
    result
  end
end
