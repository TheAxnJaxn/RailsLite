require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

require 'active_support/inflector'

require 'byebug'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      # sets file location, based on controller name and template name
      controller_name = self.class.to_s.underscore
      f_location = "views/#{controller_name}/#{template_name}.html.erb"

      # reads in a template file
      # creates a new ERB template
      # uses binding to capture the controller's instance variables
      content = ERB.new(File.read(f_location)).result(binding)

      # passes the content to render_content
      # note: content type will always be text/html since it was
      #       run through and erb processer via ERB.new above
      render_content(content, "text/html")
    end
  end
end
