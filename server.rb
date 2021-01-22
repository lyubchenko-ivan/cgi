require 'socket'
require './functions.rb'

$statuses = {
  '200' => 'OK',
  '404' => 'Not Found'
}



port = 2000

server = TCPServer.open(port)

loop do
  Thread.start(server.accept) do |client|

    request = ''


    while line = client.gets
      request << line
    end
    client.close_read

    next if request.nil?
    request = parse_request(request)

    response = response(request)

    client.puts(response)
    client.close_write
  end

end



