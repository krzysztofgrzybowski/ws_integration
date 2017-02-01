module WsIntegration
  class WorksnapsUser < ActiveRecord::Base
    def self.synchronize
      users_synchronized = 0
      api_response = HTTP.basic_auth(user: Rails.configuration.x.worksnaps_token, pass: '')
                         .get("https://api.worksnaps.com/api/users.xml").body
      Nokogiri::XML(api_response).xpath("//user").each do |ws_user|
        # index: 0 - ws_id; 4 - user_email
        ws_user = ws_user.text.split
        application_user = Rails.configuration.x.user_class_name.constantize
          .find_by(email: ws_user[4])
        if application_user
          users_synchronized += 1
          WorksnapsUser.find_or_create_by(
            worksnaps_id: ws_user[0],
            "#{Rails.configuration.x.user_class_name.downcase}_id": application_user.id
          )
        end
      end
      users_synchronized
    end

    def self.get_worksnaps_data(user)
      ws_user = WorksnapsUser.find_by(user_id: user.id)
      if ws_user
        api_response = HTTP.basic_auth(user: Rails.configuration.x.worksnaps_token, pass: '')
                           .get("https://api.worksnaps.com/api/users/#{ws_user.worksnaps_id}.xml").body
        api_response = Nokogiri::XML(api_response).xpath("//user").text.split
        return [api_response[0], api_response[1], api_response[2], api_response[3], api_response[4]]
      end
    end
  end
end
