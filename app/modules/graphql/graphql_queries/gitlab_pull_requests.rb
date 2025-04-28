
module Graphql
  module GraphqlQueries
    class GitlabPullRequests
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

      def self.fetch(owner, repo, first)
        full_path = [ owner, repo ].join("/")
        response = Client.query(
          MergeRequestsQuery,
          variables: { fullPath: full_path, first: first }
        )

        if response.errors.any?
          raise "GraphQL Error: #{response.errors[:data].join(', ')}"
        end

        response.data.project.merge_requests.edges

      end
    end
  end
end

# full_path=gitlab-org/gitlab
