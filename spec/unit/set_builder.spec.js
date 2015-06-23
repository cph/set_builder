describe 'SetBuilder'
  before_each

    SetBuilder.registerTraits([
      [['string','who are'],
        ['negative','not'],
        ['name','awesome']],
       [['string','who'],
        ['negative','have not'],
        ['name','died']],
       [['string','who were'],
        ['name','born'],
        ['modifier','date']],
       [['string','whose'],
        ['name','age'],
        ['modifier','number']],
       [['string','who have'],
        ['negative','not'],
        ['name','attended'],
        ['direct_object_type','school']],
       [['string','whose'],
        ['name','name'],
        ['modifier','string']]
    ]);

    SetBuilder.registerModifiers({
      string: {
        contains: ['string'],
        begins_with: ['string'],
        ends_with: ['string'],
        is: ['string']
      }
    });
    
    SetBuilder.registerValueMap('school', [['1','Concordia'], ['2','McKendree']]);
    
    set_data = [
      ['awesome'],
      ['attended', 2],
      ['died'],
      ['name', {'is': "Jerome"}]
    ];
    
    set_data_hash = {
      '0': {
        trait: 'awesome'
      },
      '1': {
        trait: 'attended',
        direct_object: 2
      },
      '2': {
        trait: 'died'
      },
      '3': {
        trait: 'name',
        modifiers: {
          '0': {
            operator: 'is',
            values: {
              '0': 'Jerome'
            }
          }
        }
      }
    };
  end
  
  
  
  
  describe '.getValueMap'
    it 'should return an array of arrays'
      expect(SetBuilder.getValueMap('school')).to(eql, [['1','Concordia'], ['2','McKendree']]);
    end
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
      it 'should correctly parse the name of the trait'
        var trait = new SetBuilder.Trait([['string', 'who are'], ['name', 'awesome']]);
        expect(trait.name()).to(be, 'awesome');
      end
    
      it 'should correctly identify when it expects a direct objects'
        var trait = new SetBuilder.Trait([['string', 'who have'], ['name', 'attended'], ['direct_object_type', 'string']]);
        expect(trait.requiresDirectObject()).to(be, true);
      end
    
      it 'should correctly parse paramters with modifiers'
        var trait = new SetBuilder.Trait([['string', 'who were'], ['name', 'born'], ['modifier', 'date']]);
        expect(trait.modifiers().length).to(be, 1);
      end
    end
    
  end
  
  
  
  describe '.Traits'
    before_each
      traits = SetBuilder.traits();
    end
  
    describe '.length'
      it 'should have parsed the data structure correctly'
        expect(traits.length()).to(be, 6);
      end
    end
  
    describe '.find'
      it 'should get a SetBuilder.Trait object by name'
        expect(traits.__find('awesome').name()).to(eql, 'awesome');
        expect(traits.__find('died').name()).to(eql,    'died');
        expect(traits.__find('born').name()).to(eql,    'born');
        expect(traits.__find('attended').name()).to(eql,'attended');
        expect(traits.__find('name').name()).to(eql,    'name');
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
        
      it 'should parse hash-style objects as well as arrays'
        var set = new SetBuilder.Set(set_data_hash);
        expect(set.constraints().length).to(be, 4);
      end
        
      it 'should consider two sets with identical constraints equal'
        var set1 = new SetBuilder.Set(set_data);
        var set2 = new SetBuilder.Set(set_data_hash);
        expect(set1.isEqualTo(set2)).to(be, true);
        expect(set2.isEqualTo(set1)).to(be, true);
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

