require_dependency 'has_uuid'

class Schema < ActiveRecord::Base
  include HasUuid

  belongs_to :account
  validates_presence_of :name
end
