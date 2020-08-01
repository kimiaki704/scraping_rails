require "net/http"
require "uri"
require "json"
require "time"
require "date"

class Rips::ScrapeRips < ApplicationRecord
    
    CATEGORIES = [
        62, 63, 64, 65, 342, 
        70, 71, 134, 174, 74,
        75, 82, 76, 77, 78,
        83, 153, 344, 79, 72,
        73, 160, 81, 117, 120,
        121, 127, 122, 123, 138,
        141, 143, 343, 350, 356,
        345, 346, 347, 128, 129,
        132, 133, 142, 136, 137,
        175, 176, 217, 223, 118,
        119, 135, 146, 147, 130,
        131, 158, 222, 139, 140,
        215, 220, 145, 148, 149,
        154, 155, 173, 177, 209,
        219, 286, 341, 352, 156,
        157, 178, 195, 210, 165,
        168, 207, 208, 216, 228,
        242, 348, 240, 241, 353,
        161, 150, 151, 234, 171,
        172, 224, 266, 351, 354,
        355, 202, 203, 263, 273,
        284, 205, 206, 258, 278,
        281, 274, 357, 196, 211,
        243, 257, 277, 179, 181,
        182, 183, 187, 184, 185,
        186, 255, 256, 260, 261,
        262, 264, 265, 212, 213,
        214, 244, 124, 125, 126,
        152, 159, 218, 225, 227,
        250, 166, 167, 221, 226,
        251, 169, 170, 252, 269,
        270, 285, 339, 229, 230,
        231, 246, 271, 247, 248,
        272, 67, 68, 69, 232,
        233, 298, 358, 359, 360
    ]

    def self.scrape
        headers = {
            "x-api-version" => "1",
            "accept-encoding" => "gzip;q=1.0, compress;q=0.5",
            "user-agent" => "LIPS/2.60.0 (com.lipscosme.LIPS; build:14343; iOS 13.5.1) Alamofire/4.9.1",
            "accept-language" => "ja-JP;q=1.0",
            "authorization" => "Bearer 24d6c6b3acde91d18bb84515d9cb7533a73b3f101ff02f295c2225ae6fc391af142f1640837e2e5e041d4ae06368c34e374e8ed49417210b2d62296eab8d13b2"
        }
        CATEGORIES.each do |category_id|
            # 急上昇のやつ
            # url = "https://make.appbrew.io/api/rankings/product_daily?category_id=62&client_type=ios&client_version=15&idfv=7942B2CF-04F8-4784-B2FC-AFC981A7BE04&price_range=allprice&ranking_age_group=0"
            url = "https://make.appbrew.io/api/rankings/product?category_id=#{category_id}&client_type=ios&client_version=15&idfv=7942B2CF-04F8-4784-B2FC-AFC981A7BE04&period=monthly&price_range=allprice&ranking_age_group=0"
            escapedurl = URI.escape(url)
            uri = URI.parse(escapedurl)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = url.start_with?('https') ? true : false
            req = Net::HTTP::Get.new(uri.request_uri)
            headers.each do |k, v|
                req.add_field(k, v)
            end
            res = http.request(req)
            jsons = JSON(res.body)["ranking"]["items"]
            jsons.each do |j|
                # puts "商品ID：#{json["id"]}"
                # puts "商品名：#{json["name"]}"
                # puts "クチコミ数：#{json["post_count"]}"
                # puts "商品説明：#{json["description"]}"
                # puts "カテゴリ(表示名)：#{json["category"]["display_name"]}"
                # puts "カテゴリ：#{json["category"]["name"]}"
                # puts "商品画像：#{json["image_url"]}"
                # puts "ブランド名：#{json["brand_name"]}"
                # puts "価格(税抜)：#{json["price"]}"
                # puts "価格(サイズ)：#{json["sizes_and_prices"][0]["size_and_price"]}"
                json = j["product"]
                next if json["post_count"] < 500
                rips_data = Rip.new
                rips_data["product_id"] = "#{json["id"]}"
                rips_data["name"] = "#{json["name"]}"
                rips_data["description"] = "#{json["description"]}"
                rips_data["category_display_name"] = "#{json["category"]["display_name"]}"
                rips_data["category_name"] = "#{json["category"]["name"]}"
                rips_data["image_url"] = "#{json["image_url"]}"
                rips_data["brand_name"] = "#{json["brand_name"]}"
                rips_data["price"] = "#{json["price"]}"
                rips_data["size_and_price"] = "#{json["sizes_and_prices"][0]["size_and_price"]}"
                next unless rips_data.save
            end

            puts "================ #{category_id} done!!! =================="
        end
    end
end
