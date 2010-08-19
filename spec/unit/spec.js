
JSpec.describe('SetBuilder.Set', function() {
  describe('data()', function() {
    it('should return the data you passed it', function() {
      var expected_value = 'hi';
      var set = new SetBuilder.Set(expected_value);
      expect(set.data()).to(be, expected_value);
    })
  })
})