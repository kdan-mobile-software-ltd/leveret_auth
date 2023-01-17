# frozen_string_literal: true

module Devise
  module Models
    module AuthIdentitable
      extend ActiveSupport::Concern

      included do
        has_many :identities, class_name: 'LeveretAuth::Identities',
                              foreign_key: :user_id, dependent: :destroy
      end

      module ClassMethods
        def setup_user_from_third_party(provider:, uid:, email:)
          raise LeveretAuth::Errors::ThirdPartyNotProvideEmail if email.nil? || email.empty?

          identity = LeveretAuth::Identities.find_or_initialize_by(uid: uid, provider: provider)
          return identity.user unless identity.new_record?

          identity.user = setup_with_temporary_passsword(email)
          identity.save!
          identity.user
        end

        private

        def setup_with_temporary_passsword(email)
          user = find_or_initialize_by(email: email)
          user unless user.new_record?

          user.password = SecureRandom.hex(16)
          user.skip_confirmation!
          user.save!
          user
        end
      end
    end
  end
end
