module Neo
  module Rails
  end
end

require 'neo/rails/mock'
require 'neo/rails/exposure'
require 'neo/rails/scenarios'

require 'neo/rails/engine' if defined?(::Rails)
