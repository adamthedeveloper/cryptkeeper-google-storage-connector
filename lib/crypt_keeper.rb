require Dir.pwd << '/lib/buckets.rb'
require Dir.pwd << '/lib/objects.rb'
require 'net/http'
require 'iconv'
require 'hmac-sha1'
require 'base64'
require 'uri'
require 'hpricot'

module CryptKeeper
  VERSION = "0.2.0"
  class Connection
    def initialize(*args)
      options = {
          :signature_identifier => "GOOG1",
          :host => "commondatastorage.googleapis.com",
          :port => "80"
      }

      options.merge!(args.pop) if args.last.kind_of? Hash

      @access_key   = options[:access_key]
      @secret_key   = options[:secret_key]
      @signature_id = options[:signature_identifier]
      @host = {
          :address => options[:host],
          :port => options[:port]
      }
      @ic_utf8      = Iconv.new('ascii//TRANSLIT//IGNORE', 'UTF-8')
    end

    def signature(message)
      utf8_message = @ic_utf8.iconv(message)
      utf8_key     = @ic_utf8.iconv(@secret_key)
      sha1         = HMAC::SHA1.digest(utf8_key, utf8_message)
      Base64.encode64(sha1).strip
    end

    def request_time
      Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")
    end

    include Buckets
    include Objects
  end

end