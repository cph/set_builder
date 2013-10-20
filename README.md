# SetBuilder

[![Build Status](https://travis-ci.org/boblail/set_builder.png?branch=master)](https://travis-ci.org/boblail/set_builder)
[![Code Climate](https://codeclimate.com/github/boblail/set_builder.png)](https://codeclimate.com/github/boblail/set_builder)

SetBuilder is a library for:

 * Describing a set of constraints in a simple data structure that can easily be serialized
 * Presenting that data structure in natural language
 * Performing the set of constraints as a SQL query



### Example

The following Set describes a group of people:

     [[:awesome],
      [:attended, "school"],
      [:died, :not],
      [:name, {:is => "Jerome"}]]

SetBuilder can render this Set in plain English:

    [Everyone] who is awesome, who attended school, who has not died, and whose name is Jerome.

It can also generate a NamedScope on an ActiveRecord model to fetch the people who fit in this set.



Copyright (c) 2010 Bob Lail, released under the MIT license
