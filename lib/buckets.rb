require 'hpricot'
module Buckets
  # GET Service
  # lists all of the buckets that you own
  # return an array of Bucket objects
  def buckets
    Hpricot(CryptKeeper::Connection.http_instance.get("/")).search("bucket").map do |el|
      hsh = {
          :name       => el.search("name").inner_html,
          :created_at => el.search("creationdate").inner_html
      }
      Bucket.new(hsh)
    end
  end

  # GET Bucket
  # lists the contents of a bucket or retrieves the ACLs that are
  # applied to a bucket.
  # return an array of BucketObjects
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

    hpr        = Hpricot(CryptKeeper::Connection.http_instance.get(path, bucket_name))
    obj_hashes = hpr.search("contents").map do |el|
      {
          :bucket_name        => bucket_name,
          :key                => el.search("key").inner_html,
          :last_modified      => el.search("lastmodified").inner_html,
          :e_tag              => el.search("etag").inner_html,
          :size               => el.search("size").inner_html,
          :storage_class      => el.search("storageclass").inner_html,
          :owner_id           => el.search("id").inner_html,
          :owner_display_name => el.search("displayname").inner_html
      }
    end
    obj_hashes.map { |obj| BucketMetaObject.new(obj) }
  end

  def create_bucket(*args)

  end



  class Bucket
    attr_accessor :name, :created_at

    def initialize(*args)
      options = {}
      options.merge!(args.pop) if args.last.is_a? Hash
      @name       = options[:name]
      @created_at = options[:created_at]
    end

    def create(*args)

    end

    def update(*args)

    end
  end

  class BucketMetaObject
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

    def object
      @object ||= object!
    end

    def object!
      CryptKeeper::Connection.http_instance.get("/#{URI.escape(@key)}", @bucket_name)
    end
  end
end