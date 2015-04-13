module HasUuid
  extend ActiveSupport::Concern

  included do
    after_create :generate_uuid
  end

  def generate_uuid
    write_attribute(:uuid, SecureRandom::hex(16))
  end

  def uuid
    read_attribute(:uuid)
  end
end
