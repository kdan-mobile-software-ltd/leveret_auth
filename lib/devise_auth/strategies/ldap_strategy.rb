module DeviseAuth
  module Strategies
    class LdapStrategy < BaseStrategy
      class << self
        def client
          @client ||= DeviseAuth::Ldap::Connection.new(config)
        end

        def configure(configuration)
          @config = DeviseAuth::Ldap::Configuration.new(configuration)
        end
      end

      def authenticate!
        entrys = client.search(@email)
        return if entrys.nil?

        verified_entry = entrys.find { |entry| client.bind_as(entry.dn, @password) }
        return if verified_entry.nil?

        owner_model = DeviseAuth.configuration.owner_model
        owner_model.setup_member_from_third_party('ldap', verified_entry.dn, verified_entry.mail&.first)
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
