ck_path = File.expand_path(File.dirname(__FILE__))
require ck_path + '/buckets.rb'
require ck_path + '/crypt_keeper_http.rb'
require 'uri'

module CryptKeeper
  VERSION = "0.2.7"

  # :title: Connection
  # Author:: Adam R. Medeiros (AKA: ScaryThings)
  # License:: MIT Style

  # Builds the connection to Google Storage with the credentials
  # passed in.

  # For example:
  # keeper = CryptKeeper::Connection.new({:access_key => 'your_access_key', :secret_key => 'your_secret_key'})
  class Connection
    @@http_instance = nil
    def self.http_instance
      @@http_instance
    end
    def initialize(*args)
      options = {
          :signature_identifier => "GOOG1",
          :host                 => "commondatastorage.googleapis.com",
          :port                 => "80"
      }

      options.merge!(args.pop) if args.last.kind_of? Hash
      @host = options[:host]
      @access_key = options[:access_key]
      @secret_key = options[:secret_key]
      @signature_id = options[:signature_identifier]
      @@http_instance = CryptKeeperHttp.new(@host, @access_key, @secret_key, @signature_id)
    end

    include Buckets
  end

end
