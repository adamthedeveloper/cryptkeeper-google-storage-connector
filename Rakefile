require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('cryptkeeper', '0.1.0') do |p|
  p.description    = "Work with Google Storage"
  p.url            = "http://github.com/adamthedeveloper/cryptkeeper"
  p.author         = "Adam Medeiros"
  p.email          = "adammede@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |rk_file| load rk_file }