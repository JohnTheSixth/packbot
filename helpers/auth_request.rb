module Packbot
  class AuthRequest < Sinatra::Base

    def self.check(user, pass)
      if user != ENV['SLACK_USER'] || pass != ENV['SLACK_PASS']
        return false
      else
        true
      end
    end



  # When this method is called in packbot.rb, it logs into pocket by sending a GET
  # request to the login page, pulling the unique form value from the page, then
  # submitting a POST with the form value and the email/pass specified in the .env
  # file. The result of running the method is a hash that returns the session ID,
  # the cookies with the session ID, and the most recent response from Pocket.
  def self.setup
    login_page = RestClient.get("https://getpocket.com/login")
    form_value = Nokogiri::HTML(login_page.body).css("input[class='field-form-check']")[0]["value"]
    session = { "PHPSESSID" => login_page.cookies["PHPSESSID"] }

    login_post = RestClient::Request.execute(:method => :post,
      :url => "https://getpocket.com/login_process.php",
      :headers => {
        "Accept" => "application/json, text/javascript, */*; q=0.01",
        "Accept-Encoding" => "gzip, deflate, br",
        "Accept-Language" => "en-US,en;q=0.8",
        "Connection" => "keep-alive",
        "Content-Type" => "application/x-www-form-urlencoded; charset=UTF-8",
        "DNT" => "1",
        "Host" => "getpocket.com",
        "Origin" => "https://getpocket.com",
        "Referer" => "https://getpocket.com/login",
        "X-Requested-With" => "XMLHttpRequest"
      },
      :cookies => login_page.cookies,
      :payload => {
        :feed_id => ENV['POCKET_LOGIN'],
        :password => ENV['POCKET_PASS'],
        :route => "",
        :form_check => form_value,
        :src => "",
        :source => "email",
        :source_page => "/login",
        :is_ajax => "1"
      })

    cookies = login_post.cookies.merge(session)

    # Possibly another method to run in order to get the list; I don't think it's
    # needed but I'm not ready to delete it just yet.
    #
    # login_success = RestClient::Request.execute(:method => :get,
    #   :url => "https://getpocket.com/a/queue/list/",
    #   :headers => {
    #     "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    #     "Accept-Encoding" => "gzip, deflate, sdch",
    #     "Accept-Language" => "en-US,en;q=0.8",
    #     "Connection" => "keep-alive",
    #     "DNT" => "1",
    #     "Host" => "getpocket.com",
    #     "Upgrade-Insecure-Requests" => "1"
    #   },
    #   :cookies => cookies)

    { :response => login_post, :cookies => cookies, :session => session }
  end

end
end

# All of the below is left over from logic I had to write when using HTTParty; again,
# I don't think it's needed, but I'm not ready to delete it all yet.
#
  # def self.get_cookies(headers)
  #   @sess_id = @sess_id || headers[:set_cookie].match(/(PHPSESSID\=\w+)\;/)[1]
  #
  #   hash = {}
  #
  #   headers["set-cookie"].scan(/sess_guid\=\w+[^\;]/).each do |s|
  #     if s =~ /deleted/ then next else hash[:sess_guid] = s end
  #   end
  #
  #   headers["set-cookie"].scan(/sess_start_time\=\w+[^\;]/).each do |s|
  #     if s =~ /deleted/ then next else hash[:start_time] = s end
  #   end
  #   binding.pry
  #
  #   hash
  # end
  #
  # def self.login_post_payload(form_value)
  #   {
  #     :feed_id => ENV['POCKET_LOGIN'],
  #     :password => ENV['POCKET_PASS'],
  #     :route => "",
  #     :form_check => form_value,
  #     :src => "",
  #     :source => "email",
  #     :source_page => "/login",
  #     :is_ajax => "1"
  #   }
  # end
  #
  # def self.login_post_headers(cookies)
  #   {
  #     "Accept" => "application/json, text/javascript, */*; q=0.01",
  #     "Accept-Encoding" => "gzip, deflate, br",
  #     "Accept-Language" => "en-US,en;q=0.8",
  #     "Connection" => "keep-alive",
  #     "Content-Type" => "application/x-www-form-urlencoded; charset=UTF-8",
  #     "Cookie" => cookies,
  #     "DNT" => "1",
  #     "Host" => "getpocket.com",
  #     "Origin" => "https://getpocket.com",
  #     "Referer" => "https://getpocket.com/login",
  #     "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
  #     "X-Requested-With" => "XMLHttpRequest"
  #   }
  # end
  #
  # def self.set_login_redirect_headers(cookies)
  #   {
  #     "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
  #     "Accept-Encoding" => "gzip, deflate, sdch",
  #     "Accept-Language" => "en-US,en;q=0.8",
  #     "Connection" => "keep-alive",
  #     "Cookie" => "#{@sess_id}; #{cookies[:sess_guid]}; #{cookies[:start_time]}",
  #     "DNT" => "1",
  #     "Host" => "getpocket.com",
  #     "Upgrade-Insecure-Requests" => "1",
  #     "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36"
  #   }
  # end
