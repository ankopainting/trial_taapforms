
module Taapforms
  class Engine < Rails::Engine
    rake_tasks do
      load 'taapforms/railties/setup.rake'
    end
    config.to_prepare do
      ApplicationController.helper(TaapformsHelper)
    end
  end
end
