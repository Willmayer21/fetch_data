
module Graphql
  module GraphqlQueries
    class GitLabMergeRequestsQuery
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
        response = Client.query(
          MergeRequestsQuery,
          variables: { fullPath: owner/repo, first: first }
        )

        if response.errors.any?
          raise "GraphQL Error: #{response.errors[:data].join(', ')}"
        end

        response.data.project.merge_requests.edges.map do |mr|
          {
            number: mr.node.iid,
            title: mr.node.title,
            author: mr.node.author.username
          }
        end
      end
    end
  end
end
