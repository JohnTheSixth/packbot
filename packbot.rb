# Ruby Gems
require 'sinatra'
require 'json' # for creating and parsing JSON
require 'pry'
require 'rest-client'
require 'nokogiri' # for parsing requests
require 'dotenv' # for keeping api keys and logins
Dotenv.load

# Application Classes, both depend on RestClient and Nokogiri
require_relative './pocket_login' # logs in to Pocket account
require_relative './pocket_request' # provides class and methods for API calls



before do
  content_type :json
end

error = { :text => "Your token is incorrect. Please check your Slack Integrations and update your .env file." }

get '/' do
  # redirect "enter doc url here"
  body = {
    :status => 404,
    :message => "Hello there. This URL doesn't do anything. Please refer to the documents for details.",
    :documents => "https://github.com/JohnTheSixth"
  }
  [404, body.to_json]
end

get '/authenticate' do
  # get user session info
  @pocket_session = PocketLogin.setup
  # create new PocketRequest object
  @pocket_request = PocketRequest.new
  authentication = @pocket_request.authenticate
  auth_json = JSON.parse(authentication)
  binding.pry
  redirect = @pocket_request.authorize_user(@pocket_session.cookies, auth_json["code"])
  binding.pry
end

get '/authorize' do
  body = {
    :status => 200,
    :message => "You need to authorize this application to access your account.",
    :authorization_uri => "https://github.com/JohnTheSixth"
  }
  [404, body.to_json]
end

post '/packit' do
  if ENV['SLACK_TOKEN'] == params["token"]
    send_to_pocket(params)
    message = params["text"] || "sample message"
    body = { "text" => "YOU DID IT! Here was your message:\n#{message}" }
    [200, body.to_json]
  else
    [401, error.to_json]
  end
end

get '/authorized' do
  body = {
    :status => 200,
    :message => "Successfully authorized."
  }
  [200, body.to_json]
end

get '/json_test' do
  body = { "text" => "Hi there", "user" => "pack" }
  [200, body]
end

def send_to_pocket(params)
  pocket_formatting = parse_message(params)
  request = PocketRequest.new
  auth = request.authenticate

  if /^4/ =~ auth.headers["status"]
    return parsed_response
  else
    return request.send(pocket_formatting, resp.parsed_response["code"])
  end

  binding.pry

end



def parse_message(params)
  link, tags = "", []
  values = params["text"].split(" ")

  values.each do |v|
    { :link => "", :tags => [],  }
  end
end
