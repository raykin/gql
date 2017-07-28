require "test_helper"

class GqlTest < Minitest::Test

  def test_user_type
    refute UserType.new.scalar
  end

  def test_user_query
    query = Gql::QueryOperation.new
    user = Gql::FieldExp.new('user')
    query.field_exps.push user

    fullname = Gql::FieldExp.new('name')
    sex = Gql::FieldExp.new('sex')
    user.children = [fullname, sex]

    assert_equal({:data=>{"user"=>{"name"=>"raykin", "sex"=>"man"}}}, query.cal)
  end

  def test_users_query
    query = Gql::QueryOperation.new
    users = Gql::FieldExp.new('users')

    sex = Gql::FieldExp.new('sex')
    users.children = [sex]
    query.field_exps.push users
    query.cal

    assert users.gql_type.is_a?(Gql::ListType)
    assert_equal( {:data => {"users" => [{'sex' => 'man'}, {'sex' => 'woman'}]}}, query.cal )
  end

  def test_profiles_query
    query = Gql::QueryOperation.new
    users = Gql::FieldExp.new('users')

    sex = Gql::FieldExp.new('sex')
    profile = Gql::FieldExp.new('profile')

    age = Gql::FieldExp.new('age')
    profile.children = [age]

    users.children = [sex, profile]
    query.field_exps.push users
    query.cal
    assert_equal( {:data => {"users" => [{'sex' => 'man', 'profile' => {'age' => 12}}, {'sex' => 'woman', 'profile' => nil}]}}, query.cal )
  end

  # def test_that_it_has_a_version_number
  #   refute_nil ::Gql::VERSION
  # end

end
