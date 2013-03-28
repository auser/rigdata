$:.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'app/app'

run App
