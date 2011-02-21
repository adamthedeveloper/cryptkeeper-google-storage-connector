require 'net/http'
require 'iconv'
require 'hmac-sha1'
require 'base64'
class CryptKeeperHttp

  # Request Types
  GET = "GET"
  PUT = "PUT"
  POST = "POST"
  HEAD = "HEAD"
  DELETE = "DELETE"

  def initialize(address, access_key, secret_key, signature_id)
    @address = address
    @access_key = access_key
    @secret_key = secret_key
    @signature_id = signature_id
  end

  def signature(message)
    ic_utf8 = Iconv.new('ascii//TRANSLIT//IGNORE', 'UTF-8')
    utf8_message = ic_utf8.iconv(message)
    utf8_key = ic_utf8.iconv(@secret_key)
    sha1 = HMAC::SHA1.digest(utf8_key, utf8_message)
    Base64.encode64(sha1).strip
  end

  def get(path, bucket_name='', additional_headers={})
    request(GET, path, bucket_name, nil, additional_headers)
  end

  def put(path, bucket_name='', body=nil, additional_headers={})
    request(PUT, path, bucket_name, body, additional_headers)
  end

  def delete(path, bucket_name, additional_headers={})
    request(DELETE, path, bucket_name, nil, additional_headers)
  end

  def request(type, path, bucket_name='', body=nil, additional_headers={})
    body.rewind if body && body.respond_to?(:rewind)
    bucket_name = "#{bucket_name}." if !bucket_name.empty?

    res = nil
    Net::HTTP.start(@address) do |http|
      req = Net::HTTP.const_get(type.capitalize).new(path)

      content_md5 = ''
      content_type = ''
      x_headers = ''

      if !additional_headers.empty?
        additional_headers.each do |k, v|
          req.add_field(k, v)
          x_headers << "#{k}:#{v}\n" if k[0..5] == "x-goog"
          if type==PUT
            case k
              when 'Content-MD5'
                content_md5 = v
              when 'Content-Type'
                content_type = v
            end
          end
        end
      end

      content_length = 0
      if body
        if body.respond_to? :lstat
          content_length = body.stat.size
          req.body_stream = body
        else
          content_length = body.size
          req.body = body
        end
      end

      time = Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")

      sig_path = !bucket_name.empty? ? "/#{bucket_name.gsub(/[\.]$/, path.gsub(/\?.*$/, ''))}" : "/"
      req.add_field('Host', "#{bucket_name}#{@address}")
      req.add_field('Date', time)
      req.add_field('Content-length', content_length)
      sig = "#{type}\n#{content_md5}\n#{content_type}\n#{time}\n#{x_headers}#{sig_path}"
      req.add_field('Authorization', "#{@signature_id} #{@access_key}:#{signature(sig)}")

      res = http.request(req)
    end
    res ? res.body : nil
  end
end