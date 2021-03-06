class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable
         
         
         
 def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  if user
    return user
  else
    registered_user = User.where(:email => auth.uid + "@twitter.com").first
    if registered_user
      return registered_user
    else
      user = User.create(name:auth.info.name,
        provider:auth.provider,
        uid:auth.uid,
        email:auth.uid+"@twitter.com",
        password:Devise.friendly_token[0,20],
        token: auth.credentials.token, 
        token_secret: auth.credentials.secret,
      )
    end
  end
end


def post_tweets(message)
  client =  Twitter::REST::Client.new do |config|
      config.consumer_key = configatron.twitter_appkey
      config.consumer_secret = configatron.twitter_app_secrate
      config.access_token = self.token
      config.access_token_secret = self.token_secret
    end
   
    begin
      client.update(message)
      return true
    rescue Exception => e
      self.errors.add(:oauth_token, "Unable to send to twitter: #{e.to_s}")
      logger.warn("Unable to send to twitter: #{e.to_s}")
      return false
    end
  end
end
