def response_get(request)
  response = 'HTTP/1.1 '
  if(File.file?(request[0][1][1..-1]))
    path = request[0][1][1..-1]

    response << ("200 #{$statuses['200']}\r\n")
  else
    path = 'not_find.html'
    response << ("404 #{$statuses['404']}\r\n")
  end

  # response << "Date: #{Time.now}\r\n"
  response << "Content-Length: #{File.size(path)}\r\n\r\n"
  # response << "Content-Type: text/html\r\n\r\n"
  response << response_body(path)
  return  response

end

def response_body(path)
  lines = File.readlines(path)
  body = ''
  lines.each {|line| body << line}
  return  body
end

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
