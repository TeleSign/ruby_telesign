require 'minitest/autorun'
require 'pry'
require 'telesignature'

begin
  require 'turn/autorun'
  Turn.config.format = :progress
rescue LoadError
   p 'failed to load turn'
end
