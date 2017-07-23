require "test_helper"


class ParserTest < Minitest::Test
  def test_ast
    ast = GraphQL::Parser.parse('{ hero { name sex } }')
    visitor = Gql::Visitor.new
    visitor.accept(ast)
    fe = visitor.field_tree.first
    assert_equal fe._name, 'hero'
    assert_equal 2, fe.children.size
    assert_equal ['name', 'sex'], fe.children.map(&:_name)
  end

end
