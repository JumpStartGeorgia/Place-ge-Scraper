# require gems
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'pry-byebug'
require 'active_record'
require 'mysql2'

# recursively requires all files in ./lib and down that end in .rb
Dir.glob('./lib/*').each do |folder|
  Dir.glob(folder +"/*.rb").each do |file|
    require file
  end
end

# tells AR what db file to use
ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  database: ENV['DB_NAME'],
  username: ENV['DB_USERNAME'],
  password: ENV['DB_PASSWORD'],
  encoding: 'utf8',
  host: 'localhost',
  port: 3306,
  reconnect: true
)
