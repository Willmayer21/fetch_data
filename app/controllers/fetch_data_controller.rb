class FetchDataController < ApplicationController

  VALID_SOURCES = [ "Github", "Gitlab", "Bitbucket" ]
  VALID_TYPES = [ "PullRequests", "Issues" ]
  class NoValidSourceError < StandardError; end
  class NoValidTypeError < StandardError; end

  def index
    source = params["source"].camelize
    raise NoValidSourceError unless VALID_SOURCES.include? source
    type = params["type"].camelize
    raise NoValidTypeError unless VALID_TYPES.include? type
    event = source + type
    number = params["number"].to_i


    query_class = Object.const_get("Graphql::GraphqlQueries::#{event}")

    data = query_class.fetch("#{params["org"]}", "#{params["repo"]}", params["number"].to_i)

    if source == "Github"
      if type == "Issues"
        result = data.map do |edge|
          {
            title: edge.node.title,
            author: edge.node.author.login,
            mergedat: "no data"
          }
        end
      elsif type == "PullRequests"
        result = data.map do |edge|
          {
            title: edge.node.title,
            author: edge.node.author.login,
            mergedat: edge.node.merged_at
          }
        end
      end
    elsif source == "Gitlab"
        result = data.map do |edge|
          {
            title: edge.node.title,
            author: edge.node.author.username
          }
        end
    end

    # case params["source"]
    # when "gitlab"
    #   case params["type"]
    #   when "pull_requests"
    #     data = persister_class.fetch("#{params["org"]}", "#{params["repo"]}", number)
    #   else data = "error"
    #   end
    # when "github"
    #   case params["type"]
    #   when "pull_requests"
    #     data = persister_class.fetch("#{params["org"]}", "#{params["repo"]}", number)
    #   when "issues"
    #     data = persister_class.fetch("#{params["org"]}", "#{params["repo"]}", number)
    #   else data = "error"
    #   end
    # else data = "error"
    # end

    # if data != "error"
    #   render json: data
    # else
    #   not_found!
    # end

    # http://localhost:3000/fetch_data?number=10&type=pull_requests&org=gitlab&repo=gitlab&source=gitlab


  render json: result

  rescue FetchDataController::NoValidSourceError
    not_found!
  rescue FetchDataController::NoValidTypeError
    not_found!
  end
end

# full_path=gitlab-org/gitlab

# gitlab-org/gitlab
