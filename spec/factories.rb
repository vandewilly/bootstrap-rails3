Factory.define :user, :class => User do |m|
  m.email "user@comp.com"
  m.password "password"
  m.password_confirmation "password"
  m.confirmed_at Date.today
end
