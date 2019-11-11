# frozen_string_literal: true

# rubocop:disable Style/CaseEquality
# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

class Hash
  def <<(*hash)
    hash.my_each do |key, value|
      self[key] = value
    end
  end
end

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

  def my_map(proc = nil)
    return to_enum unless block_given? || proc

    copy_arr = dup
    new_object = self.class.new
    0.upto(length - 1) do
      item = copy_arr.shift
      result = proc ? proc.call(item) : yield(item)
      new_object << result
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
    ans_pattern = false
    ans_noblock = false
    ans_block = false
    my_each do |i|
      ans_pattern = true if pattern =~ i
      ans_noblock = true if i
      ans_block = true if block_given? && yield(i)
    end
    return ans_pattern if pattern
    return ans_block if block_given?

    ans_noblock
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

  def my_count(item = nil)
    if item
      items_counter = 0
      my_each do |i|
        items_counter += 1 if item == i
      end
      return items_counter
    elsif block_given?
      counter = 0
      new_object = dup
      new_object.my_each do |i|
        counter += 1 if yield(i)
      end
      return counter
    end
    return length unless block_given?
  end

  def my_inject(*args)
    new_object = dup
    if block_given?
      initial = args[0]
      memo = initial
      if initial
        new_object.my_each do |i|
          memo = yield(memo, i)
        end
      else
        memo = new_object.shift
        new_object.my_each do |i|
          memo = yield(memo, i)
        end
      end
    elsif args[0].is_a? Symbol
      memo = new_object.shift
      new_object.my_each do |i|
        memo = memo.send(args[0], i)
      end
    else
      memo = args[0]
      method = args[1]
      new_object.my_each do |i|
        memo = memo.send(method, i)
      end
    end
    memo
  end
end

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(arr)
  arr.my_inject { |acc, el| acc * el }
end

puts multiply_els([2, 3, 4])
