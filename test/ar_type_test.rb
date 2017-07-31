require 'ar_test_helper'

class ArTypeTest < Minitest::Test

  def test_blogs_query
    ast = GraphQL::Parser.parse('{ blog { title star } }')
    visitor = Gql::Visitor.new
    visitor.accept(ast)
    operation = visitor.operation
    binding.pry
    assert_equal({:data=>{"blog"=>{"title"=>"Ruby", "star"=>21}}}, operation.cal)
  end

end
