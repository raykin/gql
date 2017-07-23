module Gql
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
