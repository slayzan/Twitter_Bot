require 'dotenv'

Dotenv.load('../.env')
puts ENV['TWITTER_API_SECRET']