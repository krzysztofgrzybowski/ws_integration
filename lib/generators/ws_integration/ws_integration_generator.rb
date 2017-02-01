module WsIntegration
  class WsIntegrationGenerator < Rails::Generators::Base
    desc "This generator creates worksnaps_user migration."

    source_root File.expand_path("../templates", __FILE__)

    argument :class_name, type: :string, default: "User"

    def create_migration
      generate "migration", "create_ws_integration_worksnaps_user worksnaps_id:integer #{class_name.downcase}:references --no-assets --no-test-framework"
    end

    def add_config
      create_file "config/initializers/ws_integration.rb" do
       "Rails.configuration.x.user_class_name = '#{class_name}'\nRails.configuration.x.worksnaps_token = 'YOUR_WORKSNAPS_TOKEN'"
      end
    end
  end
end
