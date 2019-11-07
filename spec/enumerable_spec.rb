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
      subject { Array.new(10) { |i| i+=i } }
      it 'should return a an expected array' do
        expected = Array.new(10) {1}
       expect(subject.my_map { 1 }).to eql(expected)
      end
    end
    context 'when a Hash is passed' do
      hash = {a: 1, b: 2}
      it 'should return an expected Hash' do
        expected = { a: 2, b: 3 }
        expect(hash.my_map { |k,v| [k, v+1] }).to eql(expected)
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
end
