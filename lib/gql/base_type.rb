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
    def object; true end

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

  class RootType < ObjectType

  end

  class OrmType < ObjectType

  end

  class ArType < OrmType

  end

end
