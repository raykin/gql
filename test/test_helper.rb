$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "gql"
require 'pry'

require "minitest/autorun"

# Move to support.rb or sub dir when required

# Don't consider it is just a hash.
# Finally it will becomes an object with delegate data to hash
query_hash = {user: [:name]}
query_hash = {name: []}

module Gql

  class Visitor < GraphQL::Parser::Visitor
    attr_accessor :nodes, :field_exp, :field_tree

    def initialize
      @nodes = []
      @field_tree = []
    end

    def visit_document(*args)
      puts args
    end

    def visit_operation_definition(*args)
      puts args
    end

    def visit_field(field)
      fe = FieldExp.new(field.name.value, @field_tree.last)
      @field_tree.last.children << fe if @field_tree.last
      @field_tree.push FieldExp.new(field.name.value)
    end

    def end_visit_field(field)
      if @field_tree.size > 1
        @field_tree.pop
      end
    end

    def method_missing(name, node)
      @nodes << name
    end
  end

  require 'logger'
  module Logger

    class << self
      attr_accessor :logger
    end

    def self.debug(*msg)
      @logger ||= ::Logger.new(STDOUT)
      @logger.debug(msg)
    end

  end

  class Document

  end

  class RootFieldExp < FieldExp
    def root?; true end
  end

  class QueryFieldExp < RootFieldExp

    def initialize
      @_name, @results = 'Query', {}
      infer_gql_type
    end

    def cal
      @results[:data] = {}
      Logger.debug(_name, results)
      children.each do |f|
        f.results = results[:data]
        f.subject = gql_type
      end.each(&:cal)
      @results
    end
  end

  class MutationFieldExp < FieldExp
    def root?
      true
    end
  end


end

# Application Code
class QueryType < Gql::RootType

  def user
    User.new()
  end

  def users
    [User.new(), User.new('sura', 'woman')]
  end
end


class UserType < Gql::ObjectType

end

class User
  attr_accessor :name, :sex, :profile
  def initialize(name="raykin", sex="man")
    @name, @sex = name, sex
  end
end



# class MutationType < Gql::Mutation

# end
