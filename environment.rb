# load .env variables
require 'dotenv'
Dotenv.load

# require other gems
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'pry-byebug'
require 'active_record'
require 'mysql2'
require 'yaml'
require 'erb'

# recursively requires all files in ./lib and down that end in .rb
Dir.glob('./lib/**/*.rb').each do |file|
  require file
end

# tells AR what db file to use
db_config = YAML.load(ERB.new(File.read('db/config.yml')).result)['default']
ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveSupport::Inflector.inflections do |inflect|
  # Tell ad_entry to use 'ad_entries' as plural, not 'ad_entrys'
  inflect.irregular 'ad_entry', 'ad_entries'
end
