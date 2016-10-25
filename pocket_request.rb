class PocketRequest

  def initialize
    @oauth_request = "https://getpocket.com/v3/oauth/request"
    @oauth_confirm = "https://getpocket.com/v3/oauth/authorize"
    @add_url = "https://getpocket.com/v3/add"
  end

  # The Pocket API requires an initial request that will return the OAuth code.
  def authenticate
    RestClient::Request.execute(:method => :post,
      :url => @oauth_request,
      :headers => {
        "Content-Type" => "application/json; charset=UTF8",
        "X-Accept" => "application/json"
      },
      :payload => {
        :consumer_key => ENV['POCKET_CONSUMER_KEY'],
        :redirect_uri => ENV['REDIRECT_URI']
      })
  end

  def authorize_user(cookies, code)
    RestClient::Request.execute(:method => :post,
      :url => "#{@oauth_confirm}?request_token=#{code}&redirect_uri=#{ENV['REDIRECT_URI']}",
      :headers => {
        "Content-Type" => "application/json; charset=UTF8",
        "X-Accept" => "application/json"
      },
      :cookies => cookies)
  end

  # The OAuth code from the authenticate method is used in the send method.
  def send(key)
    HTTParty.post(@add_url, {
      :headers => {
        "Content-Type" => "application/json; charset=UTF8",
        "X-Accept" => "application/json"
      },
      :body => {
        #:url => formatted[:url],
        :url => "https://www.engadget.com/2016/10/09/more-galaxy-note-7-replacement-fires/",
        #:tags => formatted[:tags],
        :consumer_key => ENV['POCKET_CONSUMER_KEY'],
        :access_token => key
      }.to_json
    })
  end
end
