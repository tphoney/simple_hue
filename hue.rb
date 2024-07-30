#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'uri'
require 'faraday'
require 'pry'
require 'optparse'

options = {}

# sends the command to the hue hub and checks for errors
def send_command(ip, url, key, message)
  connection = Faraday.new(url: "http://#{ip}/api/#{key}", ssl: { verify: false })
  response   = connection.put(url, message.to_json)
  return unless response.status != 200 || response.body.include?('error')
  raise("Error sending command.\nuri: #{url}\nmessage: #{message}\nresponse: #{response.body}")
end

def alert(ip, bulb_number, key)
  url     = "lights/#{bulb_number}/state"
  message = { 'alert' => 'lselect' }
  send_command(ip, url, key, message)
end

def color(ip, bulb_number, key, color)
  url = "lights/#{bulb_number}/state"
  hue = if color == 'red'
          0
        elsif color == 'blue'
          46_920
        elsif color == 'green'
          46_920
        else
          color.to_i
        end
  message = { 'hue' => hue }
  send_command(ip, url, key, message)
end

def brightness(ip, bulb_number, key, brightness)
  # TODO: Complete this function
end

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: hue.rb [options]'

  opts.on('-i', '--ip NAME', 'IP address of the hue hub. Required.') { |v| options[:ip] = v }
  opts.on('-k', '--key KEY', 'Auth key for hub API. Required') { |v| options[:key] = v }
  opts.on('-n', '--bulb_number NUMBER', 'bulb number. Required') { |v| options[:bulb_number] = v }
  opts.on('-c', '--color COLOR', 'change color can be a number 0-65535 or pick red|green|blue') { |v| options[:color] = v }
  opts.on('-b', '--brightness NUMBER', 'change brighness 0-254') { |v| options[:brightness] = v }
  opts.on('-a', '--alert', 'send an alert') { |_v| options[:alert] = true }
end

parser.parse!
if options.empty?
  puts parser
  exit
end

if options[:ip].nil?
  puts 'ERROR: No IP Address specified.'
  puts 'Use --help to find info on command line arguments.'
  exit
end

if options[:key].nil?
  puts 'ERROR: No API Key specified.'
  puts 'Use --help to find info on command line arguments.'
  exit
end

if options[:bulb_number].nil?
  puts 'ERROR: No bulb number specified.'
  puts 'Use --help to find info on command line arguments.'
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
