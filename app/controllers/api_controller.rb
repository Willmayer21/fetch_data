require "net/http"

class ApiController < ApplicationController
  def index
    jo = params["source"]
    render json: jo
  end

  def call
    uri = URI("https://gitlab.com/api/v4/events?target_type=issue&action=created&after=2017-01-31&before=2017-03-01&scope=all")
    req = Net::HTTP::Get.new(uri)
    req['PRIVATE-TOKEN'] = 'glpat-wPni72zZJSkZueXwzDMM'
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end


    render json: res.body
    # jo = params["type"]
    # render json: jo
  end
end
