SetBuilder
==========

[![Build Status](https://travis-ci.org/boblail/set_builder.png?branch=master)](https://travis-ci.org/boblail/set_builder)

[![Code Climate](https://codeclimate.com/github/boblail/set_builder.png)](https://codeclimate.com/github/boblail/set_builder)

SetBuilder's purpose is to transform _described_ data sets into queries or natural language.



Example
=======

The following set describes a group of people using simple data structures (Arrays, Strings, Symbols, and Hashes):

     [[:awesome],
      [:attended, "school"],
      [:died, :not],
      [:name, {:is => "Jerome"}]]

SetBuilder can render this set in plain English:

    [Everyone] who is awesome, who attended school, who has not died, and whose name is Jerome.

It can also generate a NamedScope on an ActiveRecord model to fetch the people who fit in this set.


Usage
=====



Roadmap
=======

Right now SetBuilder uses ActiveRecord::NamedScope::Scope internally, but it shouldn't be hard to refactor it to use DataMapper's composable queries instead.


Copyright (c) 2010 Bob Lail, released under the MIT license
