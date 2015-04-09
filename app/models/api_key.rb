class ApiKey < ActiveRecord::Base
  validates_uniqueness_of :key
  validates_presence_of :key

  def generate_key!
    write_attribute(:key, SecureRandom.hex(16))
  end
end
