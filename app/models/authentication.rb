class Authentication

  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  class << self
    def find_from_hash(hash)
      find_by_provider_and_uid(hash['provider'], hash['uid'])
    end

    def create_from_hash(hash, user = nil)
      user ||= User.create_from_hash!(hash)
      Authentication.create(:user => user, :uid => hash['uid'], :provider => hash['provider'])
    end
  end #of self

end