module HasUuid
  extend ActiveSupport::Concern

  included do
    before_create :generate_uuid
  end

  def generate_uuid
    write_attribute(:uuid, SecureRandom::uuid)
  end

  def uuid
    read_attribute(:uuid)
  end
end
