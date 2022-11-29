require 'open-uri'
require 'nokogiri'

recherche = gets.chomp
url = "https://www.monoprix.fr/courses/search/#{recherche}/#{recherche}"
doc = Nokogiri::HTML(URI.open(url))

t = doc.to_s.match /([0-9]+,[0-9]+ € \/ (kg|l))/

p "prix trouvé : #{t[0]}"
