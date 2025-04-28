
module Graphql
  module GraphqlQueries
    class GithubPullRequests
      include Graphql::GraphqlClients::GitHubGraphqlClient

      PullRequestsQuery = Client.parse <<~GRAPHQL
        query($owner: String!, $repo: String!, $first: Int) {
          repository(owner: $owner, name: $repo){
            pullRequests(first: $first, states: OPEN) {
              edges {
                node {
                  title
                  number
                  url
                  author {
                    login
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
          PullRequestsQuery,
          variables: { owner: owner, repo: repo, first: first }
        )

        if response.errors.any?
          raise "GraphQL Error: #{response.errors[:data].join(', ')}"
        end



        response.data.repository.pull_requests.edges


      end
    end
  end
end
