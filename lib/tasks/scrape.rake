# encoding: utf-8

namespace :rips do
  desc "Rips for iOS - クチコミ500件以上データ取得"
  task :scrape_rips => :environment do
    Rips::ScrapeRips.scrape
  end
end