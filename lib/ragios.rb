require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'net/https'

require "celluloid/zmq/current"
require 'celluloid/current'

Celluloid::ZMQ.init

Bundler.require

dir = Pathname(__FILE__).dirname.expand_path + 'ragios/'

def require_all(path)
 Dir.glob(File.dirname(__FILE__) + path + '/*.rb') do |file|
   require File.dirname(__FILE__)  + path + '/' + File.basename(file, File.extname(file))
 end
end


#notifiers
require_all '/ragios/notifiers/email'
require_all '/ragios/notifiers'
require_all '/ragios/monitors'
require_all '/ragios/database'
require_all '/ragios/web'

require_all '/ragios/plugins'

#system
require_all '/ragios'

#TODO: move this to notifications service
#global variable path to the folder with erb message files
$path_to_messages =  File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib/ragios/messages/'))
