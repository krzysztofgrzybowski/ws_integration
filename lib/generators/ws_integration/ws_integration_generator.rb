module WsIntegration
  class WsIntegrationGenerator < Rails::Generators::Base
    desc "This generator creates worksnaps_user migration."

    source_root File.expand_path("../templates", __FILE__)

    argument :class_name, type: :string, default: "user"
    argument :token, type: :string, default: "YOUR_WORKSNAPS_TOKEN"

    def create_migration
      generate "migration", "create_worksnaps_user worksnaps_id:integer #{class_name.downcase}:references"
    end

    def add_config
      create_file "config/initializers/ws_integration.rb" do
        "Rails.configuration.x.user_class_name = '#{class_name}'\nRails.configuration.x.worksnaps_token = '#{token}'"
      end
    end
  end
end
