module WsIntegration
  module WorksnapsUser
    extend ActiveSupport::Concern

    module ClassMethods
      def synchronize_with_worksnaps
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
            application_user.update_attributes(worksnaps_id: ws_user[0])
          end
        end
        users_synchronized
      end
    end

    # def get_worksnaps_data
    #   ws_user = WorksnapsUser.find_by(user_id: user.id)
    #   if ws_user
    #     api_response = HTTP.basic_auth(user: Rails.configuration.x.worksnaps_token, pass: '')
    #                        .get("https://api.worksnaps.com/api/users/#{ws_user.worksnaps_id}.xml").body
    #     api_response = Nokogiri::XML(api_response).xpath("//user").text.split
    #     return [api_response[0], api_response[1], api_response[2], api_response[3], api_response[4]]
    #   end
    # end
    #
    # def self.add_time(user, project_id, task_id, from_time, minutes)
    #   ws_user = WorksnapsUser.find_by(user_id: user.id)
    #   request_body = add_time_request_body
    #   puts request_body
    #   # HTTP.basic_auth(user: Rails.configuration.x.worksnaps_token, pass: '')
    #   #     .post("https://api.worksnaps.com/api/projects/#{project_id}/users/#{ws_user.worksnaps_id}/time_entries.xml",
    #   #     body: )
    # end
    #
    # private
    #
    # def add_time_request_body
    #   return "<time_entry>\n"\
    #          "  <task_id></task_id>\n"\
    #          "  <user_comment></user_comment>\n"\
    #          "  <from_timestamp></from_timestamp>\n"\
    #          "  <duration_in_minutes></duration_in_minutes>\n"\
    #          "</time_entry>"
    # end
  end
end