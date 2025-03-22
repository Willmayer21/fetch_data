require "graphql/client"
require "graphql/client/http"

module Graphql
  module GraphqlClients
    module GitLabGraphqlClient
      HTTP = GraphQL::Client::HTTP.new("https://gitlab.com/api/graphql") do
        def headers(context)
          {
            "Authorization" => "Bearer #{ENV["GITLAB_TOKEN"]}",
            "Content-Type" => "application/json"
          }
        end
      end

      Schema = GraphQL::Client.load_schema(HTTP)

      Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
    end
  end
end
