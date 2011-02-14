module Buckets
  # GET Service
  # lists all of the buckets that you own
  # return an array of Bucket objects
  def buckets
    Hpricot(get("/")).search("bucket").map do |el|
      hsh = {
        :name => el.search("name").inner_html,
        :created_at => el.search("creationdate").inner_html
      }
      Bucket.new(hsh)
    end
  end

  # GET Bucket
  # lists the contents of a bucket or retrieves the ACLs that are
  # applied to a bucket.
  # return an array of BucketObjects
  def bucket_objects(bucket_name, *args)
    options = {
        :delimeter => nil,
        :marker    => nil,
        :max_keys  => nil,
        :prefix    => nil
    }
    options.merge!(args.pop) if args.last.is_a? Hash

    path = "?"
    path << "delimeter=#{options[:delimeter]}&" if !options[:delimeter].nil?
    path << "marker=#{options[:marker]}&" if !options[:marker].nil?
    path << "max-keys=#{options[:max_keys]}&" if !options[:max_keys].nil?
    path << "prefix=#{options[:prefix]}&" if !options[:prefix].nil?

    hpr = Hpricot(get(path, bucket_name))
    obj_hashes = hpr.search("object").map do |el|
      {
          :name => '',
          :something => '',
          :another => ''
      }
    end
    obj_hashes.map { |obj| BucketObject.new(obj) }
  end

  def create_bucket(*args)
    
  end

  def get(path, bucket_name='')
    res = nil
    time = request_time
    Net::HTTP.start(@host[:address]) do |http|

      req = Net::HTTP::Get.new(path)
      req.add_field('Host', "#{bucket_name}#{@host[:address]}")
      req.add_field('Date', time)
      req.add_field('Content-Length',0)

      sig = signature("GET\n\n\n#{time}\n/")

      req.add_field('Authorization', "#{@signature_id} #{@access_key}:#{sig}")
      res = http.request(req)
    end
    res.body
  end

  class Bucket
    attr_accessor :name, :created_at
    def initialize(*args)
      options = {}
      options.merge!(args.pop) if args.last.is_a? Hash
      @name = options[:name]
      @created_at = options[:created_at]
    end

    def create(*args)

    end

    def update(*args)

    end

    def destroy

    end
  end

  class BucketObject
    def initialize(*args)

    end
  end
end