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

def response_body_post(path, hash)
  lines = File.readlines(path)
  answer = ''
  hash.each do |key, value|
    answer << "<li>#{key}: #{value}</li>\n    "
  end
  page = ''
  lines.each do |line|
    line.gsub!("<%= yield %>", answer)
    page << line
  end
  return  page
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

def response_post(request)
  response = 'HTTP/1.1 '
  path = request[1][1].split("/")[-1]

  if(File.file?(path))

    response << ("200 #{$statuses['200']}\r\n")
  else
    path = 'not_find.html'
    response << ("404 #{$statuses['404']}\r\n")
  end


  response << "Date: #{Time.now}\r\n"
  response << "Content-Length: #{File.size(path)}\r\n"
  response << "Content-Type: text/html\r\n\r\n"
  hash = {}
  body = request[-1][0].split('&')
  body.each {|value| hash[value.split('=')[0]] = value.split('=')[1]}

  response << response_body_post(path, hash)
  return  response
end

def response(request)
  return nil if request.nil?
  response = ''
  if request[0][0] == 'GET'
    response << response_get(request)

  else response << response_post(request)
  end
  response << "\n"
  return  response
end
