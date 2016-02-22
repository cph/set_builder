describe 'SetBuilder'
  before_each

    SetBuilder.registerTraits([
      [["string","who "],
       ["enum",["are","are not"]],
       ["string", " "],
       ["name","awesome"]],
      [["string","who "],
       ["enum",["have","have not"]],
       ["string", " "],
       ["name","died"]],
      [["string","who were "],
       ["name","born"],
       ["string", " "],
       ["modifier","date"]],
      [["string","whose "],
       ["name","age"],
       ["string", " "],
       ["modifier","number"]],
      [["string","who "],
       ["enum",["have","have not"]],
       ["string", " "],
       ["name","attended"],
       ["string", " "],
       ["direct_object_type","school"]],
      [["string","whose "],
       ["name","name"],
       ["string", " "],
       ["modifier","string"]]
    ]);

    SetBuilder.registerModifiers({
      string: {
        contains: [['arg', 'string']],
        begins_with: [['arg', 'string']],
        ends_with: [['arg', 'string']],
        is: [['arg', 'string']]
      },
      date: {
        between: [['arg', 'date'], ['string', ' and '], ['arg', 'date']]
      }
    });

    SetBuilder.registerValueMap('school', [['1','Concordia'], ['2','McKendree']]);

    set_data = [
      { trait: 'awesome', enums: ['are'] },
      { trait: 'attended', enums: ['have'], school: 2 },
      { trait: 'died', enums: ['have'] },
      { trait: 'name', modifiers: [
        { operator: 'is', values: ['Jerome'] }] }
    ];

    set_data_hash = {
      '0': { trait: 'awesome', enums: {'0': 'are'} },
      '1': { trait: 'attended', enums: {'0': 'have'}, school: 2 },
      '2': { trait: 'died', enums: {'0': 'have'} },
      '3': { trait: 'name', modifiers: {
        '0': { operator: 'is', values: {'0': 'Jerome'} } } }
    };
  end



  describe '.registerValueMap'
    it 'should accept an array of arrays as a valueMap'
      SetBuilder.registerValueMap('name', [['1', 'John'], ['2', 'Susan']]);
      expect(SetBuilder.getValueMap('name')).to(eql, [['1', 'John'], ['2', 'Susan']]);
    end

    it 'should accept and call a function as a valueMap'
      var events = [['1', 'Band Rehearsal']];
      SetBuilder.registerValueMap('event', function () { return events });
      expect(SetBuilder.getValueMap('event')).to(eql, events);
      events.push(['2', 'Basketball Practice']);
      expect(SetBuilder.getValueMap('event')).to(eql, events);
    end
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
      expect(SetBuilder.getValueMaps()).to(eql, ['school', 'name', 'event']);
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
      expect(modifiers.length()).to(be, 2);
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
        var simple_set = new SetBuilder.Set([{ trait: 'awesome', enums: {'0': 'are'} }]);
        expect(simple_set.toString()).to(eql, 'who are awesome');
      end

      it 'should generate the natural language description of a complex set'
        var set = new SetBuilder.Set(set_data);
        var expected_string = 'who are awesome, who have attended McKendree, who have died, and whose name is Jerome'
        expect(set.toString()).to(be, expected_string);
      end

      it 'should generate the natural language description of a complex set with negation (NB: nouns are not negated)'
        var set = new SetBuilder.Set([
          { trait: 'awesome', enums: ['are not'] },
          { trait: 'attended', enums: ['have not'], school: 1 },
          { trait: 'died', enums: ['have not'] },
          { trait: 'name', modifiers: [{ operator: 'is', values: ['Jerome'] }] }
        ]);
        var expected_string = 'who are not awesome, who have not attended Concordia, who have not died, and whose name is Jerome'
        expect(set.toString()).to(eql, expected_string);
      end

      it 'should generate the natural language description of a set with extra text in modifier arguments'
        var set = new SetBuilder.Set([
          { trait: 'born', modifiers: [{ operator: 'between', values: ['Jan 1, 2016', 'Jan 2, 2016'] }]}
        ])
        var expected_string = 'who were born between Jan 1, 2016 and Jan 2, 2016';
        expect(set.toString()).to(eql, expected_string);
      end
    end

  end
end
