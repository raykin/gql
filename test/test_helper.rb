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

  class FieldExp

    attr_accessor :_name, :parent, :opts, :results, :subject, :subjects, :gql_type
    attr_reader :children

    def initialize(name, parent=nil, opts=nil)
      @_name, @opts, @parent = name, opts, parent
      @children = []
      infer_gql_type
    end

    def infer_gql_type
      @gql_type ||= ("#{_name.camelize}Type".safe_constantize || find_gql_type || StringType).new
    end

    def infer_value
      @infer_value ||= if subject
        subject.send _name
      else
        subjects.map {|s| s.send _name}
      end
    end

    def children=(fields)
      @children = fields
      fields.each {|f| f.parent = self}
    end

    def find_gql_type
      # Not Implemented
    end

    def root?
      parent.nil?
    end

    # Not sure if it's a good method to use merge! to build results recursively.
    # What I concern is if it will be tricky for debug
    def cal
      Logger.debug '*'*20, _name, gql_type.inspect
      if gql_type.scalar
        results.merge! _name => infer_value
      elsif gql_type.list
        results.merge! _name => []
        children.each {|f| f.subjects = infer_value}
      elsif gql_type.object
        results.merge! _name => {}
        children.each {|f| f.subject = infer_value}
      end
      Logger.debug '+'*20, results
      if children
        children.each { |f| f.results = results[_name] }.each(&:cal)
      end
    end
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

  class BaseType

    attr_accessor :fields, :subjects, :results
    def initializes
      @results = {data: {}}
    end

    def scalar; false end
    def list; false end
    def object; false end

    def cal

      root_query_class
    end
  end

  class ObjectType < BaseType
    def object; true end

  end

  class ScalarType < BaseType
    def scalar; true end

  end

  class StringType < ScalarType

  end

  class RootType < ObjectType

  end

  class OrmType < ObjectType

  end

  class ArType < OrmType

  end
end

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
