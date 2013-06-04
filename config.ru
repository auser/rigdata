$:.unshift(File.dirname(__FILE__))
require 'sinatra'
require "./config/boot.rb"

run App