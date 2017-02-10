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

    def get_worksnaps_data
      if self.worksnaps_id
        api_response = HTTP.basic_auth(user: Rails.configuration.x.worksnaps_token, pass: '')
                           .get("https://api.worksnaps.com/api/users/#{self.worksnaps_id}.xml").body
        api_response = Nokogiri::XML(api_response).xpath("//user").text.split
        return api_response
      end
    end

    def add_worksnaps_time(project_id, task_id, from_timestamp, minutes, comment = '')
      request_body = add_time_request_body(task_id, from_timestamp, minutes, comment)
      url = "https://api.worksnaps.com/api/projects/#{project_id}/users/#{self.worksnaps_id}/time_entries.xml"
      response = HTTP.basic_auth(user: Rails.configuration.x.worksnaps_token, pass: '')
                     .post(url, body: request_body)
    end

    def delete_worksnaps_time(project_id, from_timestamp, to_timestamp)
      time_entries_url = "https://api.worksnaps.com/api/projects/#{project_id}/users/#{self.worksnaps_id}/time_entries.xml"
      time_entries_response = HTTP.basic_auth(user: Rails.configuration.x.worksnaps_token, pass: '')
                     .get(time_entries_url, params: { from_timestamp: from_timestamp, to_timestamp: to_timestamp })
      ids = Nokogiri::XML(time_entries_response).xpath("//time_entry//id")
      delete_url = "https://api.worksnaps.com/api/projects/#{project_id}/time_entries/"
      ids.each do |id|
        delete_url += id.text + ';'
      end
      delete_url = delete_url.chop + ".xml"
      delete_response = HTTP.basic_auth(user: get_worksnaps_data[7], pass: '')
                                  .delete(delete_url)
    end

    private

    def add_time_request_body(task_id, from_timestamp, minutes, comment)
      return "<time_entry>\n"\
             "  <task_id>#{task_id}</task_id>\n"\
             "  <user_comment>#{comment}</user_comment>\n"\
             "  <from_timestamp>#{from_timestamp}</from_timestamp>\n"\
             "  <duration_in_minutes>#{minutes}</duration_in_minutes>\n"\
             "</time_entry>"
    end

    def delete_time_request_body
      return
    end
  end
end
