require "lita"

module Lita
  module Handlers
    class PivotalTracker < Handler
      route(
        /^(?:pivotaltracker|pt)\s(?:add)(?:\s?(feature|bug|chore)?(.*)\s(?:to)\s(.*))*$/i,
        :pt_add,
        command: true,
        help: {
          t('help.add.syntax') => t('help.add.desc')
        }
      )

      def self.default_config(config)
        config.token = nil
      end

      def pt_add(response)
        response.reply("USAGE: #{t('help.add.syntax')}") and return if response.matches[0][1].nil? || response.matches[0][2].nil?

        project_id, project_name = id_and_name_for_project_name(response.matches[0][2])
        response.reply("Couldn't find project with name containing '#{project_name}'") and return unless project_id

        pt_params = {}

        pt_params[:story_type] = response.matches[0][0] if response.matches[0][0]
        pt_params[:name] = response.matches[0][1]

        result = api_request('post', "projects/#{project_id}/stories", pt_params)

        response.reply("BAM! Added #{result['story_type'].capitalize} '#{result['name']}' to '#{project_name}' #{result['url']}")
      end

      private

      def api_request(method, path, args = {})
        if Lita.config.handlers.pivotal_tracker.token.nil?
          Lita.logger.error('Missing Pivotal Tracker token')
          fail 'Missing token'
        end

        url = "https://www.pivotaltracker.com/services/v5/#{path}"

        http_response = http.send(method) do |req|
          req.url url, args
          req.headers['X-TrackerToken'] = Lita.config.handlers.pivotal_tracker.token
        end

        if http_response.status == 200 || http_response.status == 201
          MultiJson.load(http_response.body)
        else
          Lita.logger.error("HTTP #{method} for #{url} with #{args} " \
                            "returned #{http_response.status}")
          Lita.logger.error(http_response.body)
          nil
        end
      end

      def id_and_name_for_project_name(project_name)
        result = api_request('get', "projects")

        project_id = nil
        full_project_name = project_name
        result.each do |p|
          if p['name'].include? project_name
            project_id = p['id']
            full_project_name = p['name']
            break
          end
        end

        return project_id, full_project_name
      end
    end

    Lita.register_handler(PivotalTracker)
  end
end
