#!/usr/bin/env ruby
require 'scraperwiki'
require 'mechanize'
# require 'pry-byebug'
require 'json'

agent = Mechanize.new

agent.request_headers = { 'accept' => 'application/vnd.bountysource+json; version=2'}

# Certs downloaded from https://curl.haxx.se/ca/cacert.pem
# as published in https://curl.haxx.se/docs/caextract.html

# Update CA certs
agent.agent.http.ca_file = File.expand_path 'cacert.pem'

# Read in a page
page = agent.get("https://api.bountysource.com/teams/crystal-lang")

# Find somehing on the page using css selectors
data = JSON.parse(page.body)

puts JSON.pretty_generate(data)

# Write out to the sqlite database using scraperwiki library
ScraperWiki.save_sqlite(["timestamp"], {
  "timestamp" => Time.now.strftime('%Y%m%d_%H%M%S'),
  "activity_total" => data['activity_total'],
  "support_level_sum" => data['support_level_sum'],
  "support_level_count" => data['support_level_count'],
  "monthly_contributions_sum" => data['monthly_contributions_sum'],
  "monthly_contributions_count" => data['monthly_contributions_count'],
})
