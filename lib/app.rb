require 'dotenv'
require 'twitter'

Dotenv.load('../.env')


def login_twitter
    client = Twitter::Streaming::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
       config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
    end
end

#client.update('mon premier tweet en ruby !')
#client.update("Hello #{journalists.sample(5).join(" ")}#bonjour_monde")

def like_hello
    client = login_twitter
    tweets = client.search("#bonjour_monde", result_type: "recent").take(25)
    client.favorite(tweets)
end

def follow_hello
    client = login_twitter
    users = client.search("#bonjour_monde", result_type: "recent").take(20).map {|tweet| tweet.user.screen_name if tweet.user.screen_name != "hugomarquet3"}
    client.followers(users.compact)
end

def follow_live
    client = login_twitter
    users = client.search("#bonjour_monde", result_type: "recent").take(1)
    client.followers(users)
end

def streaming
    Dotenv.load('.env')
    streaming = Twitter::Streaming::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
    end
    client = login_twitter
    streaming.filter(track: "#bonjour_monde") do |object|
        puts object.text if object.is_a?(Twitter::Tweet)
        if object.user.screen_name != "Rosa47176539"
            client.favorite(object) if object.is_a?(Twitter::Tweet)
            client.follow(object.user.screen_name) if object.is_a?(Twitter::Tweet) && !client.friendship?(client.user, object.user)
        end
    end
end
follow_live