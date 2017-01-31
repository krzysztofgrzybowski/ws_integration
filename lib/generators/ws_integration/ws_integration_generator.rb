module WsIntegration
  class WsIntegrationGenerator < Rails::Generators::Base
    desc "This generator creates worksnaps_user migration."

    source_root File.expand_path("../templates", __FILE__)

    argument :class_name, type: :string, default: "user"

    def create_migration
      generate "migration", "create_worksnaps_user worksnaps_id:integer #{class_name.downcase}:references"
    end
  end
end
