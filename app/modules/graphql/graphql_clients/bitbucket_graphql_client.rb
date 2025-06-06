require "graphql/client"
require "graphql/client/http"




  module Graphql
    module GraphqlClients
      module BitbucketGraphqlClient
        HTTP = GraphQL::Client::HTTP.new("https://api.atlassian.com/graphql") do
          def headers(context)
            {
              "Authorization": "Bearer #{ENV["BITBUCKET_TOKEN"]}",
            }
          end
        end

        Schema = GraphQL::Client.load_schema(HTTP)

        Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
      end
    end
  end
