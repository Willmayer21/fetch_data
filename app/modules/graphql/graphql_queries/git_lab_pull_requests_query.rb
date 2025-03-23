
module Graphql
  module GraphqlQueries
    class GitLabPullRequestsQuery
      include Graphql::GraphqlClients::GitLabGraphqlClient

      MergeRequestsQuery = Client.parse <<~GRAPHQL
        query($fullPath: ID!, $first: Int) {
          project(fullPath: $fullPath) {
            mergeRequests(first: $first, state: opened) {
              edges {
                node {
                  title
                  iid
                  author {
                    username
                  }
                  createdAt
                  mergedAt
                  state
                }
              }
            }
          }
        }
          GRAPHQL

      def self.fetch(full_path, first)
        response = Client.query(
          MergeRequestsQuery,
          variables: { fullPath: full_path, first: first }
        )

        if response.errors.any?
          raise "GraphQL Error: #{response.errors[:data].join(', ')}"
        end

        response

      end
    end
  end
end
