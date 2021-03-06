Start it
  command line
    bundle exec sidekiq -q highQ,lowQ
    bundle exec sidekiq -q deafultQ
  service
    https://github.com/mperham/sidekiq/tree/master/examples/systemd
Mount the web ui
  https://github.com/mperham/sidekiq/wiki/Monitoring
  # config/routes.rb
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  Allow any authenticated User
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  Same as above but also ensures that User#admin? returns true
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
