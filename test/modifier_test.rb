require 'test_helper'

class ModifierTest < ActiveSupport::TestCase


  test "get type with class" do
    assert_equal :string, SetBuilder::Constraint::Modifier.get_type(String)
    assert_equal SetBuilder::Constraint::Modifier::String, SetBuilder::Constraint::Modifier.for(String)
  end

  test "get type with string" do
    assert_equal :string, SetBuilder::Constraint::Modifier.get_type("String")
    assert_equal SetBuilder::Constraint::Modifier::String, SetBuilder::Constraint::Modifier.for("string")
  end

  test "get type with symbol" do
    assert_equal :string, SetBuilder::Constraint::Modifier.get_type(:string)
    assert_equal SetBuilder::Constraint::Modifier::String, SetBuilder::Constraint::Modifier.for(:string)
  end

  test "registering a modifier" do
    assert_raises ArgumentError do
      SetBuilder::Constraint::Modifier.for(Hash)
    end
    SetBuilder::Constraint::Modifier.register(Hash, HashModifier)
    assert_nothing_raised ArgumentError do
      SetBuilder::Constraint::Modifier.for(Hash)
    end    
  end
  
  test "registering an invalid modifier" do
    assert_raises ArgumentError do
      SetBuilder::Constraint::Modifier.register(Hash, InvalidHashModifier)
    end
  end
  

end


class InvalidHashModifier
end

class HashModifier < SetBuilder::Constraint::Modifier::Base
  
  def self.operators
    [:has_key]
  end
  
end