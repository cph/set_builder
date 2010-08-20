describe 'Array'

  describe '.toSentence'
    it 'should return an empty string if you pass a 0-length array'
      expect([].toSentence()).to(be, '');
    end
    
    it 'should return the lone value if you pass a 1-length array'
      expect(['banana'].toSentence()).to(be, 'banana');
    end
    
    it 'should concatenate only using "and" if you pass a 2-length array'
      expect(['apple', 'banana'].toSentence()).to(be, 'apple and banana');
    end
    
    it 'should use different concatenators for a 3+-length array'
      expect(['apple', 'banana', 'chocolate'].toSentence()).to(be, 'apple, banana, and chocolate');
    end
  end
  
  describe '.dup'
    it 'should create an independently modifiable array'
      var a = [1, 2, 3];
      var b = a.dup();
      a.shift();
      expect(a.length).to(be, 2);
      expect(b.length).to(be, 3);
    end
  end
  
  describe '.each'
    it 'should correctly work through this array of arrays'
      var i = 0;
      [
        ['awesome'],
        ['attended', "school"],
        ['died'],
        ['name', {'is': "Jerome"}]
      ].each(function(item) {
        i += 1;
      });
      expect(i).to(be, 4);
    end
  end
  
  describe '.inject'
    it 'should count 4 objects in [12,32,12,11]'
      expect([12,32,12,11].inject(0, function(i, item) {
        return i + 1;
      })).to(be, 4);
    end
  end

  describe '.collect'
    it 'should make each word lowercase in ["BIG", "ANGRY", "WORDS"]'
      expect(["BIG", "ANGRY", "WORDS"].collect(function(word) {
        return word.toLowerCase();
      })).to(eql, ["big", "angry", "words"]);
    end
  end
  
  describe '.find'
    it 'should return the first word with an "a" in it'
      expect(["not", "me", "what?", "me"].find(function(word) {
        return /a/i.test(word);
      })).to(be, "what?")
    end
  end
  
end



describe 'Object'

  describe '.keys'
    it 'should return the properties of a JSON object'
      expect(Object.keys({one:1, test:2, contains:'hi'})).to(eql, ['one', 'test', 'contains']);
    end
  end

end