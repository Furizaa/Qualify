class ApiKey < ActiveRecord::Base
  belongs_to :account

  validates_uniqueness_of :key
  validates_presence_of :key

  def generate_key!
    write_attribute(:key, SecureRandom.uuid)
  end
end
