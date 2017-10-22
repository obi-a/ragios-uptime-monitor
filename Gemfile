source 'http://rubygems.org'

gem 'rufus-scheduler', '~> 3.0.7', :require => 'rufus/scheduler'
gem 'state_machine'
gem 'leanback', '~> 0.5.1'
gem 'contracts'
gem 'celluloid-zmq', '~> 0.17.2'

gem 'daemons', :group => [:services]
gem 'rake', :group => [:development, :test]

group :development do
  gem 'pry'
  gem 'foreman'
  gem 'ragios-client', '~> 0.0.7'
end

group :notifiers do
  gem 'aws-ses'
end

group :plugins do
  gem 'excon'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
end

group :web, :development do
  gem 'puma', '~> 2.10.1'
  gem 'sinatra', :require => 'sinatra/base'
end
