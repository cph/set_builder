
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

describe 'SetBuilder.Trait'
  describe '.constructor'
    it 'should correctly parse simple parameters'
      var trait = new SetBuilder.Trait(['awesome', 'reflexive']);
      expect(trait.name()).to(be, 'awesome');
      expect(trait.toString()).to(be, 'who are awesome');
    end
    
    it 'should correctly identify direct objects'
      var trait = new SetBuilder.Trait([['attended', 'string'], 'perfect']);
      expect(trait.name()).to(be, 'attended');
      expect(trait.requires_direct_object()).to(be, true);
      expect(trait.toString()).to(be, 'who have attended');
    end
    
    it 'should correctly parse paramters with modifiers'
      var trait = new SetBuilder.Trait(['born', 'passive', ['date']]);
      expect(trait.modifiers().length).to(be, 1);
      expect(trait.toString()).to(be, 'who were born');
    end
  end
end

describe 'SetBuilder.Traits'
  before_each
    traits = new SetBuilder.Traits([
      ['awesome', 'reflexive'],
      ['died', 'active'],
      ['born', 'passive', ['date']],
      [['attended', 'string'], 'perfect'],
      ['name', 'noun', ['string']]
    ]);
  end
  
  describe '.length'
    it 'should have parsed the data structure correctly'
      expect(traits.length()).to(be, 5);
    end
  end
  
  describe '.find'
    it 'should get a SetBuilder.Trait object by name'
      var trait = traits.find('awesome');
      expect(trait.toString()).to(be, 'who are awesome');
    end
  end
end

