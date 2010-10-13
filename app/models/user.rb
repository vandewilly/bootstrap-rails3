class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :admin, :access_token

  has_many :authentications

  class << self
    def create_from_hash!(hash)
      create(:access_token => "access_token")
    end
  end

end
