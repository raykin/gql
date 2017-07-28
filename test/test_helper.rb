$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "gql"
require 'pry'

require "minitest/autorun"

class ProfileType < Gql::ObjectType

end

class UserType < Gql::ObjectType

end

# Application Code
class QueryType < Gql::RootType
  add_type :hero, UserType

  def user
    User.new
  end

  def users
    [User.build_with_profile, User.new('sura', 'woman')]
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

  def self.build_with_profile
    new_user = new
    new_user.profile = Profile.new
    new_user
  end
end

class Profile
  attr_accessor :age, :location
  def initialize(age=12, location="Sh")
    @age, @location = age, location
  end
end
