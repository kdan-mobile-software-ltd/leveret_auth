# require 'leveret_auth/orm/active_record/mixins/identities'

module LeveretAuth
  class Identities < ::ActiveRecord::Base
    include LeveretAuth::Orm::ActiveRecord::Mixins::Identities
  end
end
