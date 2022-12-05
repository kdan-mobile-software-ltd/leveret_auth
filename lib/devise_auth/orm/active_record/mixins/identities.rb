# frozen_string_literal: true

module DeviseAuth::Orm::ActiveRecord::Mixins
  module Identities
    extend ActiveSupport::Concern

    included do
      self.table_name = 'identities'
      self.strict_loading_by_default = false if respond_to?(:strict_loading_by_default)

      belongs_to :owner, class_name: "::#{DeviseAuth.configuration.owner_name}",
                         inverse_of: :identities
    end
  end
end
