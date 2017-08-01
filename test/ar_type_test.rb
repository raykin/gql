require 'ar_test_helper'

class ArTypeTest < Minitest::Test

  def test_blogs_query
    result = Gql.process('{ blog { title star } }')

    assert_equal({:data=>{"blog"=>{"title"=>"Ruby", "star"=>21}}}, result)
  end

  def test_blogs_query_with_opt
    # ast = GraphQL::Parser.parse('{ blog { title star } }')
    # visitor = Gql::Visitor.new
    # visitor.accept(ast)
    # operation = visitor.operation

    # assert_equal({:data=>{"blog"=>{"title"=>"Ruby", "star"=>21}}}, operation.cal)

  end
end
