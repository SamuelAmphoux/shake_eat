require "json"
require "open-uri"

url = "https://api.edamam.com"

test1 = URI.open("#{url}/api/recipes/v2").read
puts test1
