
module Graphql
  module GraphqlQueries
    class GithubIssues
      include Graphql::GraphqlClients::GitHubGraphqlClient

      IssuesQuery = Client.parse <<~GRAPHQL
        query($owner: String!, $repo: String!, $first: Int) {
          repository(owner: $owner, name: $repo) {
            issues(first: $first, states: OPEN) {
              edges {
                node {
                  title
                  number
                  url
                  author {
                    login
                  }
                  createdAt
                  state
                }
              }
            }
          }
        }
        GRAPHQL

      # def initialize(owner, repo, first)
      #   @owner = owner
      #   @repo = repo
      #   @first = first
      # end

      def self.fetch(owner, repo, first)
        response = Client.query(
          IssuesQuery,
          variables: { owner: owner, repo: repo, first: first }
        )

        if response.errors.any?
          raise "GraphQL Error: #{response.errors[:data].join(', ')}"
        end


       response.data.repository.issues.edges

        # jojo.map do |el|
        #   puts "#{el.number}"
        # end

        # response.data.repository.issues.edges.map do |edge|
        #   edge.node
        # end



        # response.data.repository.issues.edges.map { |edge| edge.node }

      end
    end
  end
end
