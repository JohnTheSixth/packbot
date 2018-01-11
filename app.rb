module Packbot

  class App < Sinatra::Application
    enable :sessions

    use Packbot::Routes
  end

end
