module Gql
  class FieldExp

    attr_accessor :_name, :parent, :opts, :results, :subject, :subjects, :gql_type, :parent_gql_type
    attr_reader :children

    def initialize(name, parent=nil, opts=nil)
      @_name, @opts, @parent = name, opts, parent
      @children = []
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

    def infer_gql_type
      @gql_type ||= infer_gql_type_by_name || (find_gql_type || StringType).new
    end

    def infer_gql_type_by_name
      if _name.plural?
        gql_type_klass = "#{_name.singularize.camelize}Type".safe_constantize
        gql_type_klass ? ListType.new(gql_type_klass) : nil
      else
        "#{_name.camelize}Type".safe_constantize.try(:new)
      end
    end

    def find_gql_type
      Schema.find_type parent_gql_type.field_key(@_name)
    end

    def root?
      parent.nil?
    end

    # Not sure if it's a good method to use merge! to build results recursively.
    # What I concern is if it will be tricky for debug
    def cal
      infer_gql_type
      Logger.debug '*'*20, _name, gql_type.inspect
      if gql_type.scalar
        results.merge! _name => infer_value
      elsif gql_type.list
        results.merge! _name => []
        # How to make it work for ListType
        subjects.each do |value|

        end
        children.each {|f| f.subjects = infer_value; f.parent_gql_type = gql_type}
      elsif gql_type.object
        cal_object
      end
    end

    private
    def cal_list

    end

    def cal_object
      results.merge! _name => {}
      if children
        children.each do |child|
          child.subject = infer_value
          child.parent_gql_type = gql_type
          child.results = results[_name]
        end.each(&:cal)
      end
    end
  end
end
