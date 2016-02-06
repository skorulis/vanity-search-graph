require 'json'
require "net/http"
require "uri"

keywords = ["skorulis","alex skorulis","askoruli"]
filename = "search-results.json"
searches = Hash.new
currentDate = Time.new.strftime("%Y-%m-%d")

if File.exists?(filename)
	File.open(filename, 'r') { |file|
		searches = JSON.parse(file.read)
	}
end


for key in keywords
	result = `curl -Gs -d v=1.0 -d start=0 -d rsz=3 --data-urlencode q="#{key}" http://ajax.googleapis.com/ajax/services/search/web`
	json = JSON.parse(result)
	count = json["responseData"]["cursor"]["resultCount"]
	puts "count " + count + " for " + key
	
	jsonKey = key.gsub(" ","-")
	
	if searches[jsonKey] == nil
		searches[jsonKey] = Array.new
	end
	countArray = searches[jsonKey]
	
	if countArray.count > 0
		if countArray.last["date"] != currentDate
			val = Hash.new
			val["date"] = currentDate
			val["count"] = count
			countArray.push(val)
		end
	end

end

File.open(filename, 'w') { |file|
		file.write(JSON.pretty_generate(searches))
	}


