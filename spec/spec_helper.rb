require 'pry'

Dir.glob("lib/**/*.rb") { |file| require_relative "../#{file}" }
