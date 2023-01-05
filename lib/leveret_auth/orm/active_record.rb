# frozen_string_literal: true
# require 'leveret_auth/orm/active_record/identities'

module LeveretAuth
  autoload :Identities, 'leveret_auth/orm/active_record/identities'

  module Orm
    module ActiveRecord
      module Mixins
        autoload :Identities, 'leveret_auth/orm/active_record/mixins/identities'
      end

      def self.run_hooks
        models.each(&:establish_connection)
      end

      def self.models
        [
          LeveretAuth.configuration.identities_model
        ]
      end
    end
  end
end
