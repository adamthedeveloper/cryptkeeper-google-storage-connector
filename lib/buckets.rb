module Buckets
  # GET Service
  # lists all of the buckets that you own
  # return an array of Bucket objects
  def buckets
    res = nil
    time = request_time
    Net::HTTP.start(@host[:address]) do |http|

      req = Net::HTTP::Get.new("/")
      req.add_field('Host', @host[:address])
      req.add_field('Date', time)
      req.add_field('Content-Length',0)

      sig = signature("GET\n\n\n#{time}\n/")

      req.add_field('Authorization', "#{@signature_id} #{@access_key}:#{sig}")
      res = http.request(req)
    end

    hpr = Hpricot(res.body)
    bucket_hashes = hpr.search("bucket").map do |el|
      {
        :name => el.search("name").inner_html,
        :created_at => el.search("creationdate").inner_html
      }
    end

    bucket_hashes.collect { |h| Bucket.new(h) }
  end

  # GET Bucket
  # lists the contents of a bucket or retrieves the ACLs that are
  # applied to a bucket.
  # return a Bucket object
  def bucket(*args)

  end

  def create_bucket(*args)
    
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
end