require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(message(env, status, headers))
    [status, headers, body]
  end

  def message(env, status, headers)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler #{env['simpler.controller'].class}\##{env['simpler.action']}\n" \
    "Params: #{env['simpler.request_params']}\n" \
    "Response: #{status} #{headers['Content-Type']} #{env['simpler.template_path']}\n" \
  end

end
