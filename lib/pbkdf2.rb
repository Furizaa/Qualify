# Note: the pbkdf2 gem is bust on 2.0, the logic is so simple I am not sure it makes sense to have this in a gem atm (Sam)
#
# Also PBKDF2 monkey patches string ... don't like that at all
#
# Happy to move back to PBKDF2 ruby gem provided:
#
# 1. It works on Ruby 2.0
# 2. It works on 1.9.3
# 3. It does not monkey patch string
#
# See https://github.com/discourse/discourse/blob/master/lib/pbkdf2.rb

require 'openssl'
require 'xor'

class Pbkdf2

  def self.hash_password(password, salt, iterations)
    digest = OpenSSL::Digest.new("sha256")
    u = ret = prf(digest, password, salt + [1].pack("N"))

    2.upto(iterations) do
      u = prf(digest, password, u)
      ret.xor!(u)
    end

    ret.bytes.map{|b| ("0" + b.to_s(16))[-2..-1]}.join("")
  end

  protected

  def self.xor(x, y)
    x.bytes.zip(y.bytes).map{|x,y| x ^ y}.pack('c*')
  end

  def self.prf(hash_function, password, data)
    OpenSSL::HMAC.digest(hash_function, password, data)
  end

end