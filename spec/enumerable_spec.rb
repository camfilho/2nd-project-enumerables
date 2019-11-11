# frozen_string_literal: true

require './my_enum'

RSpec.describe Enumerable do
  describe '#my_each' do
    context 'when no block was given' do
      subject { Array.new(10) { |i| i += 1 } }
      it 'returns an enumerable' do
        expect(subject.my_each.class).to eql(Enumerator)
      end
    end

    context 'when neither Array or Hash was used' do
      it 'it should raise' do
        expect { 10.my_each }.to raise_error
      end
    end

    context 'when my_each returns' do
      subject { Array.new(10) }
      it 'should return self' do
        expect(subject.my_each {}).to eql(subject)
      end
    end
  end
  describe '#my_map' do
    context 'when no block is passed' do
      subject { Array.new(10) }
      it 'should return an Enumerator' do
        expect(subject.my_map.class).to eql(Enumerator)
      end
    end
    context 'when an Array is passed' do
      subject { Array.new(10) { |i| i += i } }
      it 'should return a an expected array' do
        expected = Array.new(10) { 1 }
        expect(subject.my_map { 1 }).to eql(expected)
      end
    end
    context 'when a Hash is passed' do
      hash = { a: 1, b: 2 }
      it 'should return an expected Hash' do
        expected = { a: 2, b: 3 }
        expect(hash.my_map { |k, v| [k, v + 1] }).to eql(expected)
      end
    end
  end
  describe '#my_each_with_index' do
    context 'when no block was given' do
      subject { Array.new(10) { |i| i += 1 } }
      it 'returns an enumerable' do
        expect(subject.my_each.class).to eql(Enumerator)
      end
    end

    context 'when neither Array or Hash was used' do
      it 'it should raise' do
        expect { 10.my_each }.to raise_error
      end
    end

    context 'when my_each_with_index returns' do
      subject { Array.new(10) }
      it 'should return self' do
        expect(subject.my_each {}).to eql(subject)
      end
    end
  end

  describe '#my_select' do
    context 'when no block is given' do
      it 'should return an enumerator' do
        arr = [1, 2, 3, 4]
        expect(arr.my_select.class).to eql(Enumerator)
      end
    end
    context 'when an array is passed' do
      subject { Array.new(10) { |i| i } }
      it 'should return an expected array' do
        expected = [0, 2, 4, 6, 8]
        expect(subject.my_select(&:even?)).to eql(expected)
      end
    end
  end
  describe '#my_all?' do
    context 'when no block is given' do
      it 'should return true if  none is false' do
        expect([1, 2].my_all?).to eql(true)
      end
    end
    context 'when a Hash is passed' do
      it 'returns true if condition is met' do
        hash = {a: 1, b: 2}
        expect(hash.my_all? { |key, value| value.positive? })
      end
      context 'when an Array is passed' do
        it 'returns false unless condition met' do
          array = [1,2,3,4]
          expect(array.my_all?(&:zero?)).to eql(false)
        end
      end
    end
  end
  describe '#my_any' do
    context 'when no block is given' do
      it 'should return true if  none is false' do
        expect([1, 2].my_any?).to eql(true)
      end
    end
    context 'when a Hash is passed' do
      it 'returns true if condition is met' do
        hash = {a: 1, b: 2}
        expect(hash.my_any? { |_, value| value.positive? })
      end
      context 'when an Array is passed' do
        it 'returns true if at least one zero is found' do
          array = [0,1,1,1]
          expect(array.my_any?(&:zero?)).to eql(true)
        end
      end
      context 'when a pattern is passed' do
        it  'returns false for pattern = /y/' do
          array = %w[ant bear car]
          expect(array.my_any?(/y/)).to eql(false)
        end
      end
    end
  end
  describe '#none?' do
    context 'when no block is given ' do
      it 'returns true only if none of the items is true' do
        array = [nil, nil, nil]
        expect(array.my_none?).to eql(true)
      end
    end
    context 'when applied to a Hash and block given' do
      it 'return true if block result false to all items' do
        hash = {a: 1, b: 2}
        expect(hash.my_none?{ |k, v| v > 3 }).to eql(true)
      end
    end
    context 'when applied to an Array and block_given' do
      it 'returns true if block result false to all items' do
        array = [1,2,3]
        expect(array.my_none?(&:negative?)).to eql(true)
      end
    end
    context 'when pattern applied' do
      it 'returns true if patterns doesnt match for call items' do
        array = %w[ant bear person]
        expect(array.my_none?(/z/)).to eql(true)
      end
    end
  end
  describe '#my_count' do
    context 'when no block is given' do
      it 'returns the number of items in enum' do
        array = [1, 2, 3, 4]
        expect(array.my_count).to equal(array.length)
      end
    end
    context 'when argument  item is given' do
      it 'returns the number of items that are equal to item' do
        array = Array.new(10) { |i| i }
        expect(array.my_count(2)).to eql(1)
      end
    end
    context 'when block is given' do
      it 'counts the number of elements yielding a true value.' do
        array = Array.new(10) { |i| i }
        expect(array.my_count { |i| i > 4 }).to eql(5)
      end
      it 'counts the number of Hahs Elements yield true' do
        hash = {a: 1, b: 2, c: 3}
        expect(hash.my_count { |_,v| v > 1}).to equal(2)
      end
    end
  end
  describe '#my_inject' do
    context 'when no block is passed' do
      it 'returns (item, sym) sym applied to items' do
        array = Array.new(10) { |i| i }
        expect(array.my_inject(0, :+)). to eql(array.sum)
      end
      it 'returns (sym) sym applied to enum items' do
        array = Array.new(10) { |i| i }
        expect(array.my_inject(:+)). to eql(array.sum)
      end
    end
    context 'when a block and one argument is given' do
      it 'returns memo with block appied to evey items' do
        array = Array.new(10) { |i| i }
        expect(array.my_inject(0) { |sum, n| sum + n }).to eql(array.sum)
      end
    end
    context 'when only block is given' do
      it 'returns memo with block applied to every items' do
        array = Array.new(20) { |i| i }
        expect(array.my_inject{ |sum, n| sum + n }).to eql(array.sum)
      end
    end
  end
end
