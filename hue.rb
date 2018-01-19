#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'uri'
require 'faraday'
require 'pry'
require 'optparse'

options = {}

# sends the command to the hue hub and checks for errors
def send_command(ip, url, key, message)
  connection = Faraday.new(:url => "http://#{ip}/api/#{key}", :ssl => { :verify => false })
  response   = connection.put(url, message.to_json)
  if response.status != 200 or response.body.include?('error')
    raise("Error sending command.\nuri: #{url}\nmessage: #{message}\nresponse: #{response.body}")
  end
end

def alert(ip, bulb_number, key)
  url     = "lights/#{bulb_number}/state"
  message = { "alert" => "lselect" }
  send_command(ip, url, key, message)
end

def color(ip, bulb_number, key, color)
  url = "lights/#{bulb_number}/state"
  if bulb_number == -1
    url= "groups/2/action"
  end

  if color == 'red'
    hue = 0
  elsif color == 'blue'
    hue = 46920
  elsif color == 'green'
    hue = 25500
  elsif color == 'pink'
    hue = 56100
  elsif color == 'yellow'
    hue = 12750


  elsif color == 'cycle'
    hues = [0 , 46920 , 25500 , 56100 , 12750]
    hues.each do |hue|
      message = { "hue" => hue }
      send_command(ip, url, key, message)
      sleep(5)
    end
    if hue.nil?
      return
    end
  else
    hue = color.to_i
  end
  binding.pry
  message = { "hue" => hue}

  send_command(ip, url, key, message)
end


def brightness(ip, bulb_number, key, brightness)
  url = "lights/#{bulb_number}/state"
  if brightness == 'high'
    bri = 200
  elsif brightness == 'dim'
    bri = 75
  else
    bri = 100
  end
  message = {"bri" => bri}
  send_command(ip, url, key, message)
end

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: hue.rb [options]'

  opts.on('-i', '--ip NAME', 'IP address of the hue hub. Required.') {|v| options[:ip] = v}
  opts.on('-k', '--key KEY', 'Auth key for hub API. Required') {|v| options[:key] = v}
  opts.on('-n', '--bulb_number NUMBER', 'bulb number. Required') {|v| options[:bulb_number] = v}
  opts.on('-c', '--color COLOR', 'change color can be a number 0-65535 or pick red|green|blue') {|v| options[:color] = v}
  opts.on('-b', '--brightness NUMBER', 'change brighness 0-254') {|v| options[:brightness] = v}
  opts.on('-a', '--alert', 'send an alert') {|v| options[:alert] = true}

end

  parser.parse!
  if options.empty?
    puts parser
    exit
  end

  if options[:ip].nil?
    puts "ERROR: No IP Address specified."
    puts "Use --help to find info on command line arguments."
    exit
  end

  if options[:key].nil?
    puts "ERROR: No API Key specified."
    puts "Use --help to find info on command line arguments."
    exit
  end



  if options[:bulb_number].nil?

    options[:bulb_number]= -1
  end

  if options[:bulb_number].nil?
    puts "ERROR: No bulb number specified."
    puts "Use --help to find info on command line arguments."
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

  if options[:state]
    state(options[:ip], options[:bulb_number], options[:key])
  end
