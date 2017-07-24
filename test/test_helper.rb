$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "gql"
require 'pry'

require "minitest/autorun"

# Move to support.rb or sub dir when required

module Gql

  class Visitor < GraphQL::Parser::Visitor
    attr_accessor :nodes, :field_exp, :field_tree, :operation

    def initialize
      @nodes = []
      @field_tree = []
    end

    # doc.definitions_size
    def visit_document(doc)
    end

    # available methods in odef
    # [:directives_size, :name, :operation, :selection_set, :variable_definitions_size]
    def visit_operation_definition(odef)
      @operation = case odef.operation
      when 'query'
        QueryOperation.new
      when 'mutation'
        MutationOperation.new
      else
        raise 'Unsupport operation yet'
      end
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

    def end_visit_operation_definition(odef)
      @operation.field_exps = @field_tree
    end

    def method_missing(name, node)
      @nodes << name
    end
  end


  class Operation
    attr_accessor :_name, :field_exps, :results, :gtype
    def initialize
      @results, @field_exps = {data: {}}, []
      infer_gql_type
    end

    def infer_gql_type
      @gtype ||= "#{_name.camelize}Type".safe_constantize
      if @gtype.nil?
        raise "No GraphqlType find for #{self.class.name}"
      end
    end

  end

  class QueryOperation < Operation

    def initialize
      @_name = 'query'
      super
    end

    def cal
      Logger.debug(_name, results, gtype)
      field_exps.each do |f|
        f.results = results[:data]
        f.subject = gtype.new
        f.parent_gql_type = gtype.new
      end.each(&:cal)
      @results
    end
  end

  class MutationOperation < Operation
    def initialize
      @_name = 'mutation'
      super
    end
  end

end

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
end


class User
  attr_accessor :name, :sex, :profile
  def initialize(name="raykin", sex="man")
    @name, @sex = name, sex
  end
end



# class MutationType < Gql::Mutation

# end
