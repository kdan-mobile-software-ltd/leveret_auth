# require 'devise_auth/orm/active_record/mixins/identities'

module DeviseAuth
  class Identities < ::ActiveRecord::Base
    include DeviseAuth::Orm::ActiveRecord::Mixins::Identities
  end
end
