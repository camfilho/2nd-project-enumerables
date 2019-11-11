# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

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

  def my_all?(pattern = nil)
    if pattern
      my_each do |i|
        return false unless i.match? pattern
      end
    elsif block_given?
      my_each do |i|
        return false unless yield(i)
      end
    else
      my_each do |i|
        return false unless i
      end
    end
    true
  end

  def my_any?(pattern = nil)
    if pattern
      my_each do |i|
        return true if i.match? pattern
      end
    elsif block_given?
      my_each do |i|
        return true if yield(i)
      end
    else
      my_each do |i|
        return true if i
      end
    end
    false
  end

  def my_none?(pattern = nil, &block)
    !my_all?(pattern, &block)
  end

  def my_count(item = nil)
    cnt_items = 0
    new_object = dup
    new_object.my_each do |i|
      if block_given?
        cnt_items += 1 if yield(i)
      elsif item.nil?
        cnt_items += 1
      elsif i == item
        cnt_items += 1
      end
    end
    cnt_items
  end

  def my_inject(*args)
    arg1 = args[0]
    arg2 = args[1]
    new_object = dup
    memo = arg1.is_a?(Symbol) || arg1.nil? ? new_object.shift : arg1
    new_object.my_each do |item|
      if block_given?
        memo = yield(memo, item)
      else
        sym = arg1.is_a?(Symbol) ? arg1 : arg2
        memo = memo.send(sym, item)
      end
    end
    memo
  end
end

# rubocop:enable Metrics/ModuleLength

def multiply_els(arr)
  arr.my_inject { |acc, el| acc * el }
end

puts multiply_els([2, 3, 4])
