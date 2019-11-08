# frozen_string_literal: true

module Enumerable
  class Hash
    def <<(hash)
      hash.my_each do |key, value|
        self[key] = value
      end
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

  def my_all?
    flag = true
    block_result = true
    new_object = dup
    i = 0
    while i < length
      item = new_object.shift
      block_result = yield(item) if block_given?
      unless item && block_result
        flag = false
        break
      end
      i += 1
    end
    flag
  end

  def my_any?(pattern = nil)
    i = 0
    if pattern
      while i < length
        return true if pattern =~ self[i]

        i += 1
      end
    end
    unless block_given?
      while i < length
        return true if self[i]

        i += 1
      end
    end
    new_object = dup
    while i < length
      return true if yield(new_object.shift)

      i += 1
    end
    false
  end

  def my_none?(pattern = nil)
    block_result = false
    pttrn_result = false
    object_item = false
    new_object = dup
    i = 0
    while i < length
      pttrn_result = pattern =~ self[i] if pattern
      object_item = new_object.shift unless block_given? || pattern
      block_result = yield(new_object.shift) if block_given?
      if object_item || block_result || pttrn_result
        return false
      end

      i += 1
    end
    true
  end

  def my_count(patter = nil)
    
  end
end
