require 'socket'
require './functions.rb'

$statuses = {
  '200' => 'OK',
  '404' => 'Not Found'
}

def parse_request(request = ' ')
  return nil if request.nil?
  request = request.split(/\r\n/)
  request_arr = []
  request.each do |line|
    line = line.split(/ /)
    request_arr << line
  end

  return  request_arr
end

def response(request = nil)
  return nil if request.nil?
  response = ''
  if request[0][0] == 'GET'
    response << response_get(request)
  # else response << response_post(request)
  end
  return  response
end


port = 2000

server = TCPServer.open(port)

loop do

  $client = server.accept
  request = ''
  request << $client.gets
  while line = $client.gets
    request << line
  end

  $client.puts('hello')
  next if request.nil?
  request = parse_request(request)

  response = response(request)

  $client.puts(response[0])
  $client.close

end



