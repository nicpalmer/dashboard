#!/usr/bin/ruby

require "base64"
require "json"
require "net/https"

# Declare variables for login
def getToken
username = "<CHANGE THIS"
password = "<CHANGE THIS>"
appName = "<CHANGE THIS"
busNo = "<CHANGE THIS"
scope = ""
vendorName = "<CHANGE THIS"

# Create a base-64 encoded authorization token.
encodedAuthToken = Base64.encode64(appName + "@" + vendorName + ":" + busNo)

# Specify the token service URL.
endpoint =
  URI.parse("https://api.incontact.com/InContactAuthorizationServer/Token")

# Create the post data.
postData = "{\"grant_type\":\"password\",\"username\":\"" + username +
           "\",\"password\":\"" + password +
           "\",\"scope\":\"" + scope + "\"}"

# Create the POST request headers.
headers =
  { "Accept" => "application/json, text/javascript, */*; q=0.01",
    "Authorization" => "basic #{encodedAuthToken}",
    "Content-Length" => "#{postData.bytesize}",
    "Content-Type" => "application/json; charset=UTF-8" }

# Initialize the request with endpoint (i.e. the URL).
http = Net::HTTP.new endpoint.host, endpoint.port

# Make the POST request an HTTPS POST request.
http.use_ssl = true

# Delete this line and be sure you have a valid certificate.
# The default Ruby library, net/https, doesn't check the validity of a
# certificate during a handshake. Using VERIFY_NONE is a simple, and insecure,
# hack to get around this limitation.
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# Make the request and store the response.
response = http.post(endpoint.path, postData, headers)

# The response body is in JSON, so parse it into a Ruby data structure.
token = JSON.parse(response.body)
end

# Take the token from the class above, then write it to a file.
access_token = getToken
File.write('access_token.txt', access_token["access_token"])
