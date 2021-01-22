require 'socket'


def get(path)
  request = "GET #{path} HTTP/1.1\r\nHost: localhost:1058\r\n\r\n\0"
  return request
end

def post(path, hash)
  request = "POST / HTTP/1.1\r\n"
  request << "Referer: http://localhost:1058#{path}\r\n"
  size = 0
  hash.each_value  {|value| size += value.length}
  request << "Content-length: #{size}\r\n\r\n"
  hash.each do |key, value|
    request << "#{key}=#{value}&"
  end
  request[-1] = "\r\n"
  return request
end

port = 2000
host = 'localhost'
path = '/index.html'

client = TCPSocket.open(host, port)

print "Привет, какое действие ты хочешь сделать?"
action = gets.chomp.strip.upcase


if action == 'GET'
  request = get(path)
elsif action == 'POST'
  hash = {:viking=>{}}
  print "Введите имя "
  hash[:viking][:name] = gets.chomp.strip
  print 'Введите email '
  hash[:viking][:email] = gets.chomp.strip
  request = post('/thanks.html', hash[:viking])
end

client.puts(request)
client.close_write

while !(p = client.gets).nil?
  puts p
end

client.close

