class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :admin, :login, :name

  has_many :authentications

  class << self
    def create_from_hash!(hash)
      nickname = !!(hash['user_info']['nickname'] =~ /^profile\.php/) ? hash['user_info']['name'].downcase : hash['user_info']['nickname']
      create(:login => nickname, :name => hash['user_info']['name'])
    end
  end

end
