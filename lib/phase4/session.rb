require 'json'
require 'webrick'

module Phase4
  # passed the WEBrick::HTTPRequest on initialization
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      find_cookie(req)

    end

    def find_cookie(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          cookie.value
        end
      end
    end

    def [](key)
    end

    def []=(key, val)
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
    end
  end
end


# If this cookie has been set before, it should use JSON to deserialize the value and store this in an ivar; else it should store {}
