module Gql
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
