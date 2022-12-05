# frozen_string_literal: true
# require 'devise_auth/orm/active_record/identities'

module DeviseAuth
  autoload :Identities, 'devise_auth/orm/active_record/identities'

  module Orm
    module ActiveRecord
      module Mixins
        autoload :Identities, 'devise_auth/orm/active_record/mixins/identities'
      end

      def self.run_hooks
        models.each(&:establish_connection)
      end

      def self.models
        [
          DeviseAuth.configuration.identities_model
        ]
      end
    end
  end
end
