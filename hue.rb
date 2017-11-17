#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'uri'
require 'faraday'
require 'pry'
require 'optparse'

options = {}

def alert(ip, bulb_number, key)
  connection = Faraday.new(:url => "http://#{ip}/api/#{key}", :ssl => { :verify => false })
  url = "lights/#{bulb_number}/state"
  message = {"alert":"lselect"}
  connection.put(url, message.to_json)
end

def color(ip, bulb_number, key, color)
  connection = Faraday.new(:url => "http://#{ip}/api/#{key}", :ssl => { :verify => false })
  url = "lights/#{bulb_number}/state"
  if color == 'red' 
    hue = 0
  elsif color == 'blue'
    hue = 46920
  elsif color == 'green'
    hue = 46920
  else
    hue = color.to_i
  end
  message = {"hue": hue}
  connection.put(url, message.to_json)
end

def brightness(ip, bulb_number, key, brightness)
end

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: hue.rb [options]'

  opts.on('-i', '--ip NAME', 'IP of the hue hub. Required.') { |v| options[:ip] = v }
  opts.on('-k', '--key KEY', 'Auth key for hub. Required') { |v| options[:key] = v }
  opts.on('-n', '--bulb_number NUMBER', 'bulb number. Required') { |v| options[:bulb_number] = v }
  opts.on('-c', '--color COLOR', 'change color can be a number 0-65535 or pick red|green|blue') { |v| options[:color] = v }
  opts.on('-b', '--brightness NUMBER', 'change brighness 0-254') { |v| options[:brightness] = v }
  opts.on('-a', '--alert', 'send an alert') { |v| options[:alert] = true }

end

parser.parse!
if options.empty?
  puts parser
  exit
end

if options[:alert] 
  alert(options[:ip], options[:bulb_number], options[:key])
end
if options[:color] 
  color(options[:ip], options[:bulb_number], options[:key], options[:color])
end
if options[:brightness] 
  brightness(options[:ip], options[:bulb_number], options[:key], options[:brightness])
end
