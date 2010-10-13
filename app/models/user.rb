class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :admin, :token

  has_many :authentications

  class << self
    def create_from_hash!(hash)
      create(:token => hash['credentials']['token'])
    end
  end

end
