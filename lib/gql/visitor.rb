# Deprecated
module Gql
  # Because GraphQL::Parser was removed
  class Visitor # < GraphQL::Parser::Visitor
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

    def visit_argument(arg)
      field = @field_tree.last
      key = arg.name.value
      # TODO crashed in C trace
      value_obj = arg.value
    end

    def visit_string_value(arg)
      field = @field_tree
    end

    def visit_int_value(arg)
    end

    def end_visit_field(field)
      if @field_tree.size > 1
        @field_tree.pop
      elsif @field_tree.size == 1
        @operation.field_exps.push(@field_tree.first)
        @field_tree.pop
      end
    end

    def end_visit_operation_definition(odef)
      # puts @nodes
      # Do nothing
    end

    # TODO: should remove it after gem was released.
    # It was used to test how many visitor methods avaiable because I didn't find a doc for it
    def method_missing(name, node)
      @nodes << name
    end
  end

end
