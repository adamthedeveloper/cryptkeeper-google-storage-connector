require 'net/http'
require 'iconv'
require 'hmac-sha1'
require 'base64'
class CryptKeeperHttp
  def initialize(address, access_key, secret_key, signature_id)
    @address      = address
    @access_key   = access_key
    @secret_key   = secret_key
    @signature_id = signature_id
  end

  def signature(message)
    ic_utf8      = Iconv.new('ascii//TRANSLIT//IGNORE', 'UTF-8')
    utf8_message = ic_utf8.iconv(message)
    utf8_key     = ic_utf8.iconv(@secret_key)
    sha1         = HMAC::SHA1.digest(utf8_key, utf8_message)
    Base64.encode64(sha1).strip
  end

  def get(path, bucket_name='', additional_headers={})
    bucket_name = "#{bucket_name}." if !bucket_name.empty?
    res  = nil
    time = Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")
    Net::HTTP.start(@address) do |http|

      req = Net::HTTP::Get.new(path)
      req.add_field('Host', "#{bucket_name}#{@address}")

      if !additional_headers.empty?
        additional_headers.each { |k, v| req.add_field(k, v) }
      end

      req.add_field('Date', time)
      req.add_field('Content-Length', 0)
      sig = signature("GET\n\n\n#{time}\n#{!bucket_name.empty? ? "/#{bucket_name.gsub(/[\.]$/, path.gsub(/\?.*$/,''))}" : "/"}")
      req.add_field('Authorization', "#{@signature_id} #{@access_key}:#{sig}")
      res = http.request(req)
    end
    return res.body if res
    nil
  end
end