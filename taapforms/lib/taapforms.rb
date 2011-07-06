require 'taapforms/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
#require 'taapforms/schema_scope'

module Taapforms
  class Railtie < Rails::Railtie
    initializer 'Taapforms.initialize' do |app|
      config.to_prepare do
        require_or_load 'taapforms/schema_scope'
      end
    end
  end
end
