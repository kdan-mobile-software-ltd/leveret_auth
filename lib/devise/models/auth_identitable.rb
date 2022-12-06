# frozen_string_literal: true

module Devise
  module Models
    module AuthIdentitable
      extend ActiveSupport::Concern

      included do
        has_many :identities, class_name: 'DeviseAuth::Identities',
                              foreign_key: :owner_id, dependent: :destroy
      end

      module ClassMethods
        def setup_member_from_third_party(provider:, uid:, email:)
          raise DeviseAuth::Errors::ThirdPartyNotProvideEmail if email.nil? || email.empty?

          identity = DeviseAuth::Identities.find_or_initialize_by(uid: uid, provider: provider)
          return identity.owner unless identity.new_record?

          identity.owner = setup_with_temporary_passsword(email)
          identity.save!
          member
        end

        private

        def setup_with_temporary_passsword(email)
          member = find_or_initialize_by(email: email)
          member unless member.new_record?

          member.password = Secrets.default_password
          member.skip_confirmation!
          member.save!
          member
        end
      end
    end
  end
end
