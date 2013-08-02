=begin rdoc

== Authors

Dave McNulla

== Revision Log

2013.07.30	initial files for a simple rest client

=end
class RestBaby
	attr_accessor :contentType, :uri, :wsresponse, :xId 

	def initialize(url, headers = {})
		@uri = URI.parse(url)
		@headers = headers
	end

	#Basic web services Get command
	# * url = url to send the command to
	# * headers = header parameters including authorization and Content-Type
	# The response from the rest server is returned
	def get(path, headers = {})
		return request(uri, Net::HTTP::Get.new(@uri.request_uri), headers)
	end

	#Basic web services Post command
	# * url = url to send the command to
	# * body = data to put in the body
	# * headers = header parameters including authorization and Content-Type
	# The response from the rest server is returned
	def post(path, body = nil, headers = {})
		return request(uri, Net::HTTP::Post.new(@uri.request_uri), body, headers)
	end

	#Basic web services Delete command
	# * url = url to send the command to
	# * headers = header parameters including authorization and Content-Type
	# The response from the rest server is returned
	def delete(path, headers = {})
		return request(uri, Net::HTTP::Delete.new(@uri.request_uri), headers)
	end

	#Basic web services Put command
	# * url = url to send the command to
	# * body = data to put in the body
	# * headers = header parameters including authorization and Content-Type
	# The response from the rest server is returned
	def put(path, body = nil, headers = {})
		return request(uri, Net::HTTP::Put.new(@uri.request_uri), body, headers)
	end

	#Sending the web services command
	# * url = url to send the command to
	# * req = command to send as Net::HTTP:<command> class
	# * body = data to put in the body
	# * headers = header parameters including authorization and Content-Type
	# The response from the rest server is returned
	def request(uri, request, body = nil, headers)
		@headers.merge(headers).each { |key, value| request[key] = value }
		request.body = body unless body.nil?
		http = Net::HTTP.new(@uri.host, @uri.port)
		begin
			@wsresponse = http.request(request)
			return @wsresponse
		rescue Timeout::Error => e 
			raise e.message
		end
	end
	
	def get_code
		@wsresponse.code
	end

	# Pretty print the web services response
	# * response = web service response to print
	def print_last_response
		response = @wsresponse
		output = "CODE = #{response.code}\n"
		output << "MESSAGE = #{response.message}\n"
		response.each { |key, value| output << "#{key} = #{value}\n"}
		begin
			output << "BODY = "
		  output << "#{body(response.body)}\n" 
		rescue
			output << "[Empty]"
		end
		return output
	end
	
end