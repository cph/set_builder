require 'test_helper'

class PredicatesTest < ActiveSupport::TestCase


  test "predicates" do
    assert_equal ["is awesome"], SomeModel.predicates.collect(&:name)
  end


end


class SomeModel
  extend QueryBuilder::Predicates
  predicate "is awesome"
end