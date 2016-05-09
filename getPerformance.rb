# Calls the API to retrieve a list of skill summaries for all skills.

require "base64"
require "json"
require "net/https"
require "rubygems" # Needed on Mac.
require "active_support"
require "active_support/core_ext"

def getPerformance(startDate="2016-05-01", endDate="2016-05-09")

# Check that startDate is a string in yyyy-mm-ddThh:mm:ss+/-hh:mm form.
  unless startDate.is_a?(String) &&
         startDate =~ /\d\d\d\d-\d\d-\d\d(T\d\d:\d\d:\d\d[\S]*)?/
    raise ArgumentError,
      "startDate must be a string in yyyy-mm-ddThh:mm:ss+/-hh:mm form"
  end

  # Check that endDate is a string in yyyy-mm-ddThh:mm:ss+/-hh:mm form.
  unless endDate.is_a?(String) &&
         endDate =~ /\d\d\d\d-\d\d-\d\d(T\d\d:\d\d:\d\d[\S]*)?/
    raise ArgumentError,
      "endDate must be a string in yyyy-mm-ddThh:mm:ss+/-hh:mm form"
  end

  # Pull the access token and base URL from the response body.
  accessToken = File.read("access_token.txt")
  baseURL = "https://api-C16.incontact.com/inContactAPI/"

  # Create the URL that accesses the API.
  apiURL = "services/v6.0/skills/sla-summary?startDate=#{startDate}&endDate=#{endDate}"
  uri = URI(baseURL + apiURL)


  # Create the GET request headers.
  headers =
    { "Accept" => "application/json, text/javascript, */*; q=0.01",
      "Authorization" => "bearer #{accessToken}",
      "Content-Type" => "application/x-www-form-urlencoded",
      "Data-Type" => "json" }

  # Set up an HTTP object.
  http = Net::HTTP.new uri.host, uri.port

  # Make the GET request an HTTPS GET request.
  http.use_ssl = true

  # Delete this line and be sure you have a valid certificate.
  # The default Ruby library, net/https, doesn't check the validity of a
  # certificate during a handshake. Using VERIFY_NONE is a simple, and insecure,
  # hack to get around this limitation.
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # Make the request and store the response.
  response = http.request_get(baseURL + apiURL, headers)

  # The data the API returns is in JSON, so parse it if it's valid.
  data = if response.body != ""
      JSON.parse(response.body)
    else
      "The response was empty."
  end

  # Now you can do something with the data the API returned.
end

slaStates = getPerformance
puts JSON.pretty_generate(slaStates)
