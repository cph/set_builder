describe 'SetBuilder'
  before_each
    traits = new SetBuilder.Traits([
      ['awesome', 'reflexive'],
      ['died', 'active'],
      ['born', 'passive', ['date']],
      [['attended', 'string'], 'perfect'],
      ['name', 'noun', ['string']]
    ]);
    set_data = [
      ['awesome'],
      ['attended', "school"],
      ['died'],
      ['name', {'is': "Jerome"}]
    ];
  end
  
  
  
  describe '.Trait'
  
    describe '.constructor'
      it 'should correctly parse simple parameters'
        var trait = new SetBuilder.Trait(['awesome', 'reflexive']);
        expect(trait.name()).to(be, 'awesome');
        expect(trait.toString()).to(eql, 'who are awesome');
      end
    
      it 'should correctly identify direct objects'
        var trait = new SetBuilder.Trait([['attended', 'string'], 'perfect']);
        expect(trait.name()).to(be, 'attended');
        expect(trait.requires_direct_object()).to(be, true);
        expect(trait.toString()).to(eql, 'who have attended');
      end
    
      it 'should correctly parse paramters with modifiers'
        var trait = new SetBuilder.Trait(['born', 'passive', ['date']]);
        expect(trait.modifiers().length).to(be, 1);
        expect(trait.toString()).to(eql, 'who were born');
      end
    end
    
  end
  
  
  
  describe '.Traits'
  
    describe '.length'
      it 'should have parsed the data structure correctly'
        expect(traits.length()).to(be, 5);
      end
    end
  
    describe '.find'
      it 'should get a SetBuilder.Trait object by name'
        expect(traits.find('awesome').toString()).to(eql, 'who are awesome');
        expect(traits.find('died').toString()).to(eql,    'who died');
        expect(traits.find('born').toString()).to(eql,    'who were born');
        expect(traits.find('attended').toString()).to(eql,'who have attended');
        expect(traits.find('name').toString()).to(eql,    'whose name');
      end
    end
    
  end
  
  
  
  describe '.Set'
    before_each
      set = new SetBuilder.Set(traits, set_data);
    end
    
    describe '.constraints'
      it 'should have parsed the correct number of objects'
        expect(set.constraints().length).to(be, 4);
      end
    end
  
    describe '.toString'
      it 'should generate the natural language description of a simple set'
        var simple_set = new SetBuilder.Set(traits, [['awesome']]);
        expect(simple_set.toString()).to(eql, 'who are awesome');
      end
      
      it 'should generate the natural language description of a complex set'
        var expected_string = 'who are awesome, who have attended school, who died, and whose name is Jerome'
        expect(set.toString()).to(be, expected_string);
      end
    end
  end
end

