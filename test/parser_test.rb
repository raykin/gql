require "test_helper"


class ParserTest < Minitest::Test
  def test_ast
    ast = GraphQL::Parser.parse('{ hero { name sex } }')
    visitor = Gql::Visitor.new
    visitor.accept(ast)
    operation = visitor.operation
    fe = operation.field_exps.first
    assert_equal fe._name, 'hero'
    assert_equal 2, fe.children.size
    assert_equal ['name', 'sex'], fe.children.map(&:_name)
    assert_equal({:data=>{"hero"=>{"name"=>"aka", "sex"=>"man"}}}, operation.cal)
  end

  def test_ast_1
    ast = GraphQL::Parser.parse('{ hero { name } liliya }')
    visitor = Gql::Visitor.new
    visitor.accept(ast)
    operation = visitor.operation
    assert_equal 2, operation.field_exps.size
    assert_equal({:data=>{"hero"=>{"name"=>"aka"}, "liliya" => "lili"}}, operation.cal)
  end
end
