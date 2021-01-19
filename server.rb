require 'socket'
require './functions.rb'

$statuses = {
  '200' => 'OK',
  '404' => 'Not Found'
}



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



