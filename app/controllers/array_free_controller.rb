class ArrayFreeController < ApplicationController
  def index
    result = problem
    render json: result
  end

  def problem
    num = [ 2, 7, 11, 15 ]
    num.map.with_index do |el, i|
      if i + 1
      p "--------------"

       p el + num[i+1]
       p el + num[i+2]
       p el + num[i+3]

      p "--------------"
    end
  end
end
