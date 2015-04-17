require_dependency 'has_uuid'

class Schema < ActiveRecord::Base
  include HasUuid

  belongs_to :account
  validates_presence_of :name
  validates_length_of :name, in: 1..32, allow_blank: false
end
