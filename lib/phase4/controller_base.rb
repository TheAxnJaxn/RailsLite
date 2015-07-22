require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    # calls parent method and calls store session after
    def redirect_to(url)
      super(url)
      @session.store_session(@res)
    end

    # calls parent method and calls store session after
    def render_content(content, content_type)
      super(content, content_type)
      @session.store_session(@res)
    end

    # parses the request and constructs a session from it
    def session
      @session ||= Session.new(@req)
    end
  end
end
