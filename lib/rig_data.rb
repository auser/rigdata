$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require "backend/version"
require 'yaml'
require 'rainbow'
Sickill::Rainbow.enabled = true

module RigData
  def self.log(msg, opts={})
    color = opts[:fg] || :blue
    puts "========> #{msg}".foreground(color.to_sym)
  end
  def self.config_cache
    @config_cache ||= {}
  end
  def self.config(path)
    unless config_cache[path]
      file = File.join(File.dirname(__FILE__), "..", "config", "#{path}.yml")
      config_cache[path] = YAML.load_file(file)
    end
    config_cache[path]
  end
end

%w(spouts bolts topologies).each do |dir|
  Dir["#{File.dirname(__FILE__)}/backend/#{dir}/**/*.rb"].each {|f| require f}
end

