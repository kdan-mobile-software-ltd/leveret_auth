# frozen_string_literal: true

require 'net/ldap'

module LeveretAuth
  module Ldap
    class Connection
      def initialize(configuration)
        @configuration = if configuration.is_a?(Configuration)
                           configuration
                         else
                           Configuration.new(configuration)
                         end
        @connection = Net::LDAP.new(@configuration.connection_config)
      end

      def search(value)
        @connection.search(filter: build_filter(value))
      end

      def bind_as(entry_dn, password)
        @connection.bind(method: :simple, username: entry_dn, password: password)
      end

      private

      def build_filter(value)
        if @configuration.filter && !@configuration.filter.empty?
          Net::LDAP::Filter.construct(@configuration.filter % { username: value })
        else
          Net::LDAP::Filter.eq(@configuration.uid, value)
        end
      end
    end
  end
end
