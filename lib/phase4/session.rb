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
          @hash=JSON.parse(cookie.value)
        end
      end

      if @hash.nil?
        @hash={}
      end
    end

    # returns the requested session content
    def [](key)
      @hash[key]
    end

    # modifies the session content
    def []=(key, val)
      @hash[key] = val
    end

    # serializes the hash into json
    # saves in a cookie named '_rails_lite_app'
    # adds to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @hash.to_json)
    end
  end
end
