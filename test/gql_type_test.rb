require "test_helper"

class GqlTypeTest < Minitest::Test

  def test_type_name
    assert_equal 'User', UserType.type_name
  end

  def test_root_type_name
    assert_equal 'Gql::Ar', Gql::ArType.type_name
  end

  def test_hero_type
    # => return {"70281084560200 hero"=>UserType} not good design
    puts Gql::Schema.types
  end
end
