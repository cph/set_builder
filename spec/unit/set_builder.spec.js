describe 'SetBuilder'
  before_each

    SetBuilder.registerTraits([
      ['awesome', 'reflexive'],
      ['died', 'active'],
      ['born', 'passive', ['date']],
      [['attended', 'school'], 'perfect'],
      ['name', 'noun', ['string']]
    ]);

    SetBuilder.registerModifiers({
      string: {
        contains: ['string'],
        begins_with: ['string'],
        ends_with: ['string'],
        is: ['string']
      }
    });

    SetBuilder.registerValueMap('school', {'1':'Concordia', '2':'McKendree'});

    set_data = [
      ['awesome'],
      ['attended', 2],
      ['died'],
      ['name', {'is': "Jerome"}]
    ];
  end
  
  
  
  describe '.getValue'
    it 'should return a value based on the key and name'
      expect(SetBuilder.getValue('school', 1)).to(be, 'Concordia')
      expect(SetBuilder.getValue('school', '1')).to(be, 'Concordia')
    end
    
    it 'should return what it was passed if there is no value map for the key'
      expect(SetBuilder.getValue('band', 1)).to(be, 1)
    end
  end
  
  describe '.getValueMaps'
    it 'should return the names of the value maps registered'
      expect(SetBuilder.getValueMaps()).to(eql, ['school']);
    end
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
    before_each
      traits = SetBuilder.traits();
    end
  
    describe '.length'
      it 'should have parsed the data structure correctly'
        expect(traits.length()).to(be, 5);
      end
    end
  
    describe '.find'
      it 'should get a SetBuilder.Trait object by name'
        expect(traits.__find('awesome').toString()).to(eql, 'who are awesome');
        expect(traits.__find('died').toString()).to(eql,    'who died');
        expect(traits.__find('born').toString()).to(eql,    'who were born');
        expect(traits.__find('attended').toString()).to(eql,'who have attended');
        expect(traits.__find('name').toString()).to(eql,    'whose name');
      end
    end
    
  end



  describe '.Modifiers'
    before_each
      modifiers = SetBuilder.modifiers();
    end

    describe '.length'
      it 'should have parsed the data structure correctly'
        expect(modifiers.length()).to(be, 1);
      end
    end

    describe '.operators_for'
      it 'should get the modifiers for the "string" modifier'
        var expected_modifiers = ['contains', 'begins_with', 'ends_with', 'is'];
        expect(modifiers.operators_for('string')).to(eql, expected_modifiers);
      end
    end

  end
  
  describe '.Set'
    
    describe '.constraints'
      it 'should have parsed the correct number of objects'
        var set = new SetBuilder.Set(set_data);
        expect(set.constraints().length).to(be, 4);
      end
    end
  
    describe '.toString'
      it 'should generate the natural language description of a simple set'
        var simple_set = new SetBuilder.Set([['awesome']]);
        expect(simple_set.toString()).to(eql, 'who are awesome');
      end
      
      it 'should generate the natural language description of a complex set'
        var set = new SetBuilder.Set(set_data);
        var expected_string = 'who are awesome, who have attended McKendree, who died, and whose name is Jerome'
        expect(set.toString()).to(be, expected_string);
      end

      it 'should generate the natural language description of a complex set with negation (NB: nouns are not negated)'
        var set = new SetBuilder.Set([
          ['!awesome'],
          ['!attended', 1],
          ['!died'],
          ['!name', {'is': "Jerome"}]
        ]);
        var expected_string = 'who are not awesome, who have not attended Concordia, who have not died, and whose name is Jerome'
        expect(set.toString()).to(eql, expected_string);
      end
    end
    
  end
end

