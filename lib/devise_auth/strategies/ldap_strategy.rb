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
        raise ActiveRecord::RecordNotFound if entrys.nil?

        verified_entry = entrys.find { |entry| client.bind_as(entry.dn, @password) }
        raise Errors::InvalidCredential if verified_entry.nil?

        user_model.setup_user_from_third_party(uid: verified_entry.dn,
                                               provider: 'ldap',
                                               email: @email)
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
