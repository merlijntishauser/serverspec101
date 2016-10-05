 require 'docker'
 require 'serverspec'
 
 RSpec.configure do |config|
   config.color = true
   config.tty = true
   config.formatter = :documentation # :progress, :html, :textmate
 end

