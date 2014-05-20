require "lita"
require "lita-keyword-arguments"

module Lita
  module Handlers
    class PivotalTracker < Handler
      route(
        /^(pt)\s(?:a|add)+.+$/i,
        :pt_add,
        command: true,
        help: {
          "pt add [-p | --project PROJECT_NAME] [-n | --name STORY_NAME] [-d | --description STORY_DESCRIPTION] [-e | --estimate STORY_ESTIMATE] [-t | --type STORY_TYPE]" => "Add a story to Pivotal Tracker with the name specified for the project specified. The 'feature' type is used by default."
        },
        kwargs: {
          project: {
            short: "p"
          },
          name: {
            short: "n"
          },
          description: {
            short: "d"
          },
          type: {
            short: "t",
            default: "feature"
          },
          # labels: {
          #   short: "l"
          # },
          # owner: {
          #   short: "o"
          # },
          # requester: {
          #   short: "r"
          # },
          estimate: {
            short: "e"
          }
        }
      )

      def self.default_config(config)
        config.token = nil
      end

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

      def pt_add(response)
        # TODO: Add requesters/owners to stories, use /projects/{project_id}/memberships to get people
        project_id, project_name = id_and_name_for_project_name(response.extensions[:kwargs][:project])
        pt_params = {}

        pt_params[:name] = response.extensions[:kwargs][:name] if response.extensions[:kwargs][:name]
        pt_params[:description] = response.extensions[:kwargs][:description] if response.extensions[:kwargs][:description]
        pt_params[:story_type] = response.extensions[:kwargs][:type] if response.extensions[:kwargs][:type]
        pt_params[:estimate] = response.extensions[:kwargs][:estimate] if response.extensions[:kwargs][:estimate]

        result = api_request('post', "projects/#{project_id}/stories", pt_params)

        response.reply("BAM! Added #{result['story_type'].capitalize} '#{result['name']}' to '#{project_name}' #{result['url']}")
      end

      def id_and_name_for_project_name(project_name)
        result = api_request('get', "projects")

        project_id = nil
        full_project_name = nil
        result.each do |p|
          if p['name'].include? project_name
            project_id = p['id']
            full_project_name = p['name']
            break
          end
        end

        unless project_id
          Lita.logger.error("Couldn't find project with name containing '#{project_name}'")
          fail 'Unknown project'
        end
        return project_id, full_project_name
      end
    end

    Lita.register_handler(PivotalTracker)
  end
end
