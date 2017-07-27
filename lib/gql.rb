require "gql/version"
require 'active_support/core_ext/string'
require 'logger'

require 'graphql/parser'

require 'gql/core_ext'
require 'gql/field_exp'
require 'gql/base_type'
require 'gql/schema'
require 'gql/visitor'
require 'gql/operation'

module Gql

  module Logger

    class << self
      attr_accessor :logger
    end

    def self.debug(*msg)
      @logger ||= ::Logger.new(STDOUT)
      @logger.debug(msg)
    end

  end

end
