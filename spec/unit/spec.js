
describe 'SetBuilder.Set'
  describe '.data'
    it 'should return the data you passed it'
      var expected_value = 'hi';
      var set = new SetBuilder.Set(expected_value);
      expect(set.data()).to(be, expected_value);
    end
  end
end