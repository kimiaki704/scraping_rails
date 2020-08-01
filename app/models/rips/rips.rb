require "net/http"
require "uri"
require "json"
require "time"
require "date"

class Rips::Rips < ApplicationRecord
  def self.scrape
    headers = {
        "x-api-version" => "1",
        "accept-encoding" => "gzip;q=1.0, compress;q=0.5",
        "user-agent" => "LIPS/2.60.0 (com.lipscosme.LIPS; build:14343; iOS 13.5.1) Alamofire/4.9.1",
        "accept-language" => "ja-JP;q=1.0",
        "authorization" => "Bearer 24d6c6b3acde91d18bb84515d9cb7533a73b3f101ff02f295c2225ae6fc391af142f1640837e2e5e041d4ae06368c34e374e8ed49417210b2d62296eab8d13b2"
    }
    # 急上昇のやつ
    # url = "https://make.appbrew.io/api/rankings/product_daily?category_id=62&client_type=ios&client_version=15&idfv=7942B2CF-04F8-4784-B2FC-AFC981A7BE04&price_range=allprice&ranking_age_group=0"
    url = "https://make.appbrew.io/api/rankings/product?category_id=63&client_type=ios&client_version=15&idfv=7942B2CF-04F8-4784-B2FC-AFC981A7BE04&period=monthly&price_range=allprice&ranking_age_group=0"

    escapedurl = URI.escape(url)
    uri = URI.parse(escapedurl)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = url.start_with?('https') ? true : false
    req = Net::HTTP::Get.new(uri.request_uri)
    headers.each do |k, v|
        req.add_field(k, v)
    end
    res = http.request(req)
    json = JSON(res.body)

    puts json["ranking"]["items"]
  end
end
