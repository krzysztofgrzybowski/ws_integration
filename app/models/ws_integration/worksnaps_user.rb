module WsIntegration
  class WorksnapsUser < ActiveRecord::Base
    def self.synchronize
      puts '**********************************************'
      puts 'TOKEN: ' + Rails.configuration.x.worksnaps_token
      puts HTTP.basic_auth(user: Rails.configuration.x.worksnaps_token, pass: '')
                .get("https://api.worksnaps.com/api/users.xml").body
      puts '**********************************************'
    end
  end
end
