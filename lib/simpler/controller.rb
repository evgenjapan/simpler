require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    protected

    def set_status(status_code)
      @response.status = status_code
    end

    def set_header(header, value)
      response[header.to_s] = value
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.merge!(@request.env["simpler.request_params"])
    end

    def render(template)
      if template.is_a?(Hash)
        @request.env['simpler.response_type'] = template.keys.first
        @request.env['simpler.response_data'] = template.values.first
      else
        @request.env['simpler.template'] = template
      end
    end

  end
end
