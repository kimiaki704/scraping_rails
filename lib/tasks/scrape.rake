# encoding: utf-8

namespace :rips do
  desc "Rips for iOS - クチコミ500件以上データ取得"
  task :rips => :environment do
    Rips::Rips.scrape
  end
end