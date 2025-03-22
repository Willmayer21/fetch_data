require "graphql/client"
require "graphql/client/http"




  module Graphql
    module GraphqlClients
      module GitHubGraphqlClient
        HTTP = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
          def headers(context)
            {
              "Authorization": "Bearer ",
            }
          end
        end

        Schema = GraphQL::Client.load_schema(HTTP)

        Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
      end
    end
  end
