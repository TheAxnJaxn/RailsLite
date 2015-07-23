require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      # sets params ivar to a hash of keys and values, or {}
      # each method call needs to return at least an empty hash to deep_merge
      @params = parse_www_encoded_form(req.query_string)
                .deep_merge(parse_post_body(req))
                .deep_merge(route_params)
    end

    # params getter method that responds to both string & sym keys
    def [](key)
      return @params[key.to_s] if @params.has_key?(key.to_s)
      return @params[key.to_sym] if @params.has_key?(key.to_sym)
      return nil
    end

    # useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private

    # helper method that parses a URI encoded string
    # and returns {} OR a deeply nested hash
    def parse_www_encoded_form(www_encoded_form)
      return {} if www_encoded_form.nil?
      # creates array version
      query_array = URI::decode_www_form(www_encoded_form)
      helper(query_array)
    end


    # returns either {} or the parsed req post body for the params hash
    def parse_post_body(req)
      return {} if req.body.nil?
      body_array = URI::decode_www_form(req.body)
      helper(body_array)
    end

    # takes an array with a key, value pair and returns nested hash
    def helper(array)
      nest_it = {}

      array.each do |k_v_p|
        hashy = {}
        keys_array = parse_key(k_v_p.first)
        value = k_v_p.last

        hashy = hashify(keys_array, value) || {}
        nest_it = nest_it.deep_merge(hashy)

      end

      nest_it
    end
    
    # hashifies an array and leaf, such that
    # hashify(["user","address","street"], "main") =>
    # { user => { address => { street => main }}}
    def hashify(arr, leaf)
      # commented out because arr will never be empty
      # if(arr.length == 0)
      #   return nil
      # end

      hashBrown = {arr.last => leaf}
      arr.reverse.drop(1).each {
        | item | hashBrown = {item => hashBrown}
      }

      return hashBrown
    end

    # returns an Array of the String key
    # parse_key('user[address1][street1]') returns ['user', 'address1', 'street1']
    def parse_key(key)
      # key.scan(/[a-z]/)
      key.scan(/[^\[\]]+/)
    end
  end
end
