require "irkit"

module Ruboty
  module Handlers
    class IRKit < Base
      NAMESPACE = "irkit"

      env :IRKIT_CLIENTKEY, "clientkey for IRKit"
      env :IRKIT_DEVICEID,  "deviceid for IRKit"

      on(/irkit (get|read) (?<name>.+)/, name: "get", description: "Get IR Data")
      on(/irkit (post|write) (?<name>.+)/, name: "post", description: "Post IR Data")
      on(/irkit show (?<name>.+)/, name: "show", description: "Show IR Data")
      on(/irkit import (?<name>.+) (?<json>.+)/, name: "import", description: "Import IR Data")
      on(/irkit delete (?<name>.+)/, name: "delete", description: "Delete IR Data")
      on(/irkit rename (?<old_name>.+) (?<new_name>.+)/, name: "rename", description: "Rename IR Data to new name")
      on(/irkit list/, name: "list", description: "Show list of IR Data")

      def get(message)
        name = message[:name]
        message.reply "Please send IR message \"#{name}\" to IRKit."
        ir_data = client.get_messages(clear: 1)
        if ir_data
          data[name] = ir_data.message.to_json
          message.reply "Received IR message \"#{name}\"."
        else
          message.reply "Can't find IR message \"#{name}\"."
        end
      end

      def post(message)
        name = message[:name]
        if data[name]
          response = client.post_messages JSON.parse(data[name])
          if response.code == 200
            message.reply "IR message \"#{name}\" is succeeded."
          else
            message.reply "IR message \"#{name}\" is failed."
          end
        else
          message.reply "IR message \"#{name}\" is not registered."
        end
      end

      def show(message)
        name = message[:name]
        if data[name]
          message.reply data[name]
        else
          message.reply "IR message \"#{name}\" is not registered."
        end
      end

      def import(message)
        name = message[:name]
        json = message[:json]
        data[name] = json
        message.reply "Imported IR message \"#{name}\"."
      end

      def delete(message)
        name = message[:name]
        if data[name]
          data.delete name
          message.reply "IR message \"#{name}\" is deleted."
        else
          message.reply "IR message \"#{name}\" is not registered."
        end
      end

      def rename(message)
        old_name = message[:old_name]
        new_name = message[:new_name]
        if data[old_name]
          data[new_name] = data[old_name]
          data.delete old_name
          message.reply "IR message \"#{old_name}\" is changed to \"#{new_name}\"."
        else
          message.reply "IR message \"#{old_name}\" is not registered."
        end
      end

      def list(message)
        message.reply data.keys.join("\n")
      end

      private

      def client
        @client ||= ::IRKit::InternetAPI.new(clientkey: ENV['IRKIT_CLIENTKEY'], deviceid: ENV['IRKIT_DEVICEID'])
      end

      def data
        robot.brain.data[NAMESPACE] ||= {}
      end
    end
  end
end
