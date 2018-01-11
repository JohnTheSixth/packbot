# require gems from Gemfile
require 'rubygems'
require 'bundler'
Bundler.require

# require Ruby libraries
require 'json'

# require helpers
Dir.glob('./helpers/*.rb').each { |file| require file }

# require app files
require './routes'
require './app'

run Packbot::App
