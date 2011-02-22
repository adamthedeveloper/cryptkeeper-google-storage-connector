require 'hpricot'
require 'digest/md5'
module Buckets

  # GET Service
  # lists all of the buckets that you own
  # return an array of Bucket objects
  def buckets
    find_buckets
  end

  # returns the connection object that was initialized
  def connection
    CryptKeeper::Connection.http_instance
  end

  # create a bucket. Takes a Hash as it's argument
  # {:name => 'my_new_bucket_name'}
  def create_bucket(*args)
    options = args.last
    connection.put("/", options[:name])
    find_buckets(options)
  end

  # search for buckets by name
  # {:name => 'my_bucket_name'}
  def find_buckets(*args)
    options = args.last
    name = options[:name] if options.is_a? Hash
    buckets = Hpricot(connection.get("/")).search("bucket").map do |el|
      Bucket.new(
          {
              :name => el.search("name").inner_html,
              :created_at => el.search("creationdate").inner_html
          }
      )
    end
    name.nil? ? buckets : buckets.reject { |bucket| bucket.name != name }[0]
  end

  # GET Bucket
  # lists the contents of a bucket or retrieves the ACLs that are
  # applied to a bucket.
  # returns an array of BucketMetaObjects
  # takes a bucket name and hash for options.
  # Possible keys for the hash are
  # * :delimeter
  # * :marker
  # * :max_keys
  # * :prefix
  def bucket_meta_objects(bucket_name, *args)
    options = {
        :delimeter => nil,
        :marker    => nil,
        :max_keys  => nil,
        :prefix    => nil
    }
    options.merge!(args.pop) if args.last.is_a? Hash

    path = "/?"
    path << "delimeter=#{options[:delimeter]}&" if !options[:delimeter].nil?
    path << "marker=#{options[:marker]}&" if !options[:marker].nil?
    path << "max-keys=#{options[:max_keys]}&" if !options[:max_keys].nil?
    path << "prefix=#{options[:prefix]}&" if !options[:prefix].nil?
    path.gsub!(/[&]$/, '')

    hpr        = Hpricot(connection.get(path, bucket_name))
    hpr.search("contents").map do |el|
      BucketMetaObject.new(
          {
              :bucket_name => bucket_name,
              :key => el.search("key").inner_html,
              :last_modified => el.search("lastmodified").inner_html,
              :e_tag => el.search("etag").inner_html,
              :size => el.search("size").inner_html,
              :storage_class => el.search("storageclass").inner_html,
              :owner_id => el.search("id").inner_html,
              :owner_display_name => el.search("displayname").inner_html
          }
      )
    end
  end

  # Utils class
  class Utils

    # returns a connection instance
    def connection
      CryptKeeper::Connection.http_instance
    end
  end

  # Bucket
  class Bucket < Utils
    attr_accessor :name, :created_at

    def initialize(*args)
      options = {}
      options.merge!(args.pop) if args.last.is_a? Hash
      @name       = options[:name]
      @created_at = options[:created_at]
    end

    # Delete this bucket if it's empty
    def delete(options={})
      connection.delete("/", @name)
    end

    #
    #def update(*args)

    #end

    # add an object to this bucket
    # pass in a name, a File or IO object, it's content type and a hash
    # containing additional headers (keys and values)
    def add_object(name, data, content_type='binary/octet-stream', *args)
      data.rewind
      additional_headers = {
          'Content-MD5' => Base64.encode64(Digest::MD5.digest(data.read)).strip,
          'Content-Type' => content_type
      }
      additional_headers.merge!(args.pop) if args.last.is_a? Hash
      connection.put("/#{URI.escape(name)}", @name, data, additional_headers)
    end
  end

  # BucketMetaObject
  # Contains information about an object
  class BucketMetaObject < Utils
    attr_accessor :properties,
                  :key, :last_modified, :e_tag, :size, :storage_class,
                  :owner_id, :owner_display_name,
                  :bucket_name

    def initialize(*args)
      @properties         = args.first
      @bucket_name        = @properties[:bucket_name]
      @key                = @properties[:key]
      @last_modified      = @properties[:last_modified]
      @e_tag              = @properties[:e_tag]
      @size               = @properties[:size]
      @storage_class      = @properties[:storage_class]
      @owner_id           = @properties[:owner_id]
      @owner_display_name = @properties[:owner_display_name]
    end

    # When called, returns the previously set data of the object. If the object data
    # hasn't been set, it will go fetch it from Google Storage and set it as an instance
    # variable to be returned next time.
    def object
      @object ||= object!
    end

    # Forces retrieval of the object data from Google Storage.
    def object!
      connection.get("/#{URI.escape(@key)}", @bucket_name)
    end

    # Deletes the object from the bucket.
    def delete
      connection.delete("/#{URI.escape(@key)}", @bucket_name)
    end

    def copy_to(bucket_name, path=nil)
      path = "/#{path.nil? ? URI.escape(@key) : URI.escape(path)}"
      connection.put(path, bucket_name, nil, {'x-goog-copy-source' => "#{@bucket_name}/#{URI.escape(@key)}"})
    end
  end
end