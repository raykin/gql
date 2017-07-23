module Gql
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
end
