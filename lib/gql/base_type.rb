module Gql
  class BaseType

    def scalar; false end
    def list; false end
    def object; false end

    def self.field_key(field_name)
      "#{object_id} #{field_name}"
    end

    # TODO: how to test it, it always dynamic
    def self.add_type(field_name, type_klass)
      Schema.insert_type(field_key(field_name), type_klass)
    end

    def field_key(field_name)
      self.class.field_key(field_name)
    end

  end

  class ObjectType < BaseType
    attr_accessor :fields_def

    def initialize
      @fields_def = {}
      super
    end

    def object; true end

    def self.inherited(subclass)
      subclass.singleton_class.class_eval { attr_accessor :type_name }
      subclass.type_name = subclass.name.sub 'Type', ''
    end

    # TODO: Why we need it
    # Doesn't ruby already has introspection?
    def self.method_added(method_name)
      if public_method_defined?(method_name)
        puts method_name
        # TODO: possible recognize if method is public or private
        if fields_def.has_key? method_name
        end
      end
    end

  end

  class ScalarType < BaseType
    def scalar; true end
  end

  class ListType < BaseType
    attr_accessor :item_type
    def initialize(item_type)
      @item_type = item_type
    end

    def list; true end
  end

  # TODO: it is possible to make it as singleton
  class StringType < ScalarType

  end

  class OrmType < ObjectType

  end

  class ArType < OrmType

  end

end
