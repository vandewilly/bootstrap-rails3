class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :admin, :login, :name

  has_many :authentications

  class << self
    def create_from_hash!(hash)
      create(:login => hash['user_info']['nickname'], :name => hash['user_info']['name'])
    end
  end

end
