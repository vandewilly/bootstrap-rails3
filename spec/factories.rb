Factory.define :user, :class => User do |m|
  m.token 'abcd'
end

Factory.define :authentication, :class => Authentication do |m|
  m.uid '1234567890'
  m.provider 'facebook'
  m.association :user, :factory => :user
end