require 'json'

if ARGV.count != 2
    puts "Usage: ruby check_results.rb countString searchTerm"
    abort
end

resultCount = ARGV[0].gsub ',' , ""
query = ARGV[1]
regexPattern = /of [0-9]+/

number = resultCount.scan(regexPattern)[0]
number = number.slice(3,number.length-3)

puts "Looking in " + resultCount + " for term " + query

key = query.gsub(" ","-")

filename = "search-results.json"

searches = Hash.new

if File.exists?(filename)
	File.open(filename, 'r') { |file|
		searches = JSON.parse(file.read)
	}
end

if searches[key] == nil
	searches[key] = Array.new
end

countArray = searches[key]

currentDate = Time.new.strftime("%Y-%m-%d")
last = false
if countArray.count > 0
	last = countArray.last["date"] == currentDate
end

if !last
	File.open(filename, 'w') { |file|
		val = Hash.new
		val["date"] = currentDate
		val["count"] = number
		countArray.push(val)
		file.write(searches.to_json)
		puts "wrote value " + number
	}
end

