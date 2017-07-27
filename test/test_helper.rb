$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "gql"
require 'pry'

require "minitest/autorun"

class UserType < Gql::ObjectType

end

# Application Code
class QueryType < Gql::RootType
  add_type :hero, UserType

  def user
    User.new()
  end

  def users
    [User.new(), User.new('sura', 'woman')]
  end

  def hero
    User.new('aka', 'man')
  end

  def liliya
    'lili'
  end
end

class User
  attr_accessor :name, :sex, :profile
  def initialize(name="raykin", sex="man")
    @name, @sex = name, sex
  end
end
