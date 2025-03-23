class FetchDataController < ApplicationController
  def index
    number = params["number"].to_i
    case params["source"]
    when "gitlab"
      case params["type"]
      when "pull_requests"
        data = Graphql::GraphqlQueries::GitLabPullRequestsQuery.fetch("#{params["org"]}/#{params["repo"]}", number)
      else data = "error"
      end
    when "github"
      case params["type"]
      when "pull_requests"
        data = Graphql::GraphqlQueries::GitHubPullRequestsQuery.fetch("#{params["org"]}", "#{params["repo"]}", number)
      when "issues"
        data = Graphql::GraphqlQueries::GitHubIssuesQuery.fetch("#{params["org"]}", "#{params["repo"]}", number)
      else data = "error"
      end
    else data = "error"
    end

    # if data != "error"
    #   render json: data
    # else
    #   not_found!
    # end


    if data == "error"
      not_found!
    else
      render json: data
    end
  end
end

# full_path=gitlab-org/gitlab

# add suport for bitbucket

# source
# type
# full_path
# org
# repo
# number



# gitlab-org/gitlab
