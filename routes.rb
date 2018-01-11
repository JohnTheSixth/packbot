module Packbot
  class Routes < Sinatra::Application
    register Sinatra::Flash

    get '/' do
      puts params
      erb :index
    end

    get '/authenticate' do
      erb :authenticate
    end

    post '/authenticate' do
      puts params
      if Packbot::AuthRequest.check(params[:user], params[:pass]) == false
        flash[:error] = 'The user email or password did not match what the application expects.'
        redirect '/authenticate'
      end
    end

    get '/confirm' do
      erb :confirm
    end

    post '/pack' do

    end

  end
end
