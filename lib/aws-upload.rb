require "net/http"
require "aws-sigv4"
module NakiCommon

  def self.aws_upload payload, path, access_key_id, secret_access_key, header = {}
    "https://storage.yandexcloud.net/#{path}".tap do |url|
      code, response = ( ::Net::HTTP.new("storage.yandexcloud.net", 443).tap{ |_| _.use_ssl = true }.start do |http|
        http.request ::Net::HTTP::Put.new(
          url,
          ::Aws::Sigv4::Signer.new(
            service: "s3", region: "ru-central1",
            access_key_id: access_key_id,
            secret_access_key: secret_access_key
          ).sign_request(http_method: "PUT", url: url, body: payload, headers: header).
            headers.merge(header)
        ).tap{ |_| _.body = payload }
      end )
      unless ["200", nil] == [code.code, response]
        ::STDERR.puts code, response
        fail "PUT failed"
      end
    end
  end

end
