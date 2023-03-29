require 'leveret_auth/strategies/base_strategy'
require 'leveret_auth/ldap/configuration'
require 'leveret_auth/ldap/connection'

module LeveretAuth
  module Strategies
    class LdapStrategy < BaseStrategy
      class << self
        def client
          @client ||= Ldap::Connection.new(config)
        end

        def configure(configuration)
          @config = Ldap::Configuration.new(configuration)
        end
      end

      def verify
        entrys = client.search(@email)
        raise Errors::InvalidCredential if entrys.nil?

        verified_entry = entrys.find { |entry| client.bind_as(entry.dn, @password) }
        raise Errors::InvalidCredential if verified_entry.nil?

        yield auth_info(verified_entry)
      end

      def auth_info(entry)
        {
          provider: 'ldap',
          uid: entry.uid,
          info: {
            email: entry.email
          },
          extra_info: {}
        }
      end

      private

      def permitted_attrs
        %i[email password]
      end

      def client
        self.class.client
      end
    end
  end
end
