module Gql
  module Schema

    class << self
      attr_accessor :types


      def insert_type(key, type_klass)
        types[key] = type_klass
      end

      def find_type(key)
        types[key]
      end
    end
    self.types = {}

  end

end
