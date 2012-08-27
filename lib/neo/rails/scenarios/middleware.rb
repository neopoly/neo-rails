require 'sass'
module Neo
  module Rails
    module Scenarios
      class Middleware
        def initialize(app)
          @app = app
        end

        def call(env)
          status, headers, response = @app.call(env)
          builder = ResponseBuilder.new(status, headers, response, env[Scenarios::ENV_KEY])
          builder.response
        end

        private

        class ResponseBuilder

          def initialize(status, headers, response, scenarios)
            @status, @headers, @response, @scenarios = status, headers, response, scenarios
          end

          def response
            inject! html_to_inject, js_to_inject, style_to_inject if @scenarios && html?
            [@status, @headers, @response]
          end

          private

          def html?
            @headers['Content-Type'] && @headers['Content-Type'].to_s.include?('text/html')
          end

          def inject!(*contents)
            @response.each do |fragment|
              fragment.gsub! %r(</body>), contents.join
            end
          end

          def html_to_inject
            links = @scenarios.map{|s| "<li>#{s.link}</li>"}
            "<div class='neo-rails-scenarios-list'><h2>Scenarios<span class='caret'/></h2><ul>#{links.join}</ul></div>"
          end

          def js_to_inject
            File.open File.expand_path('../assets/scenario_list.js', __FILE__) do |f|
              "<script type='text/javascript'>#{f.read}</script>"
            end
          rescue
            ''
          end

          def style_to_inject
            compiled = Sass.compile_file File.expand_path('../assets/scenario_list.css.sass', __FILE__)
            "<style type='text/css' media='all'>#{compiled}</style>"
          rescue
            ''
          end
        end
      end
    end
  end
end
