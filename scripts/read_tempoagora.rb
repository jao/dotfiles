#!/usr/bin/ruby
require 'net/http'
require 'uri'

city = ARGV.size > 0 ? ARGV.join : 'Curitiba-PR'

url = URI.parse("http://tempoagora.uol.com.br/selos/txt/#{city}.txt")
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}
options = {}
res.body.split('&').collect {|p| k,v = p.split('='); options[k] = v }

# needs to be converted from iso-8859-1 to utf-8
puts %{
Cidade: #{options['cidade']}
  Dia: #{options['dia1']}
  Tempo: #{options['tempo1']}
  Mínima: #{options['min1']}
  Máxima #{options['max1']}
}