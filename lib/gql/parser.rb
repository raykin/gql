module Gql
  # Wrapper for GraphQL::Parser
  class Parser

    def self.operation(str)
      ast = GraphQL::Parser.parse(str)
      visitor = Gql::Visitor.new
      visitor.accept(ast)
      visitor.operation
    end
  end

end
