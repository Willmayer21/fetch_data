class ArrayController < ApplicationController
  def index
    arrays = [
      {
        "id": "gid://gitlab/DiffNote/2482606038",
        "author": {
          "id": "gid://gitlab/User/188307"
        },
        "body": "this is a great opinion",
        "createdAt": "2025-05-03T09:37:10Z"
      },
      {
        "id": "gid://gitlab/Note/2482606041",
        "author": {
          "id": "gid://gitlab/User/188307"
        },
        "body": "Looks good to me",
        "createdAt": "2025-05-03T09:37:11Z"
      },
      {
        "id": "gid://gitlab/Note/2482606042",
        "author": {
          "id": "gid://gitlab/User/188307"
        },
        "body": "approved this merge request",
        "createdAt": "2025-05-03T09:37:11Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2482861436",
        "author": {
          "id": "gid://gitlab/User/188307"
        },
        "body": "this is another comment for another review",
        "createdAt": "2025-05-04T09:55:25Z"
      },
      {
        "id": "gid://gitlab/Note/2482861441",
        "author": {
          "id": "gid://gitlab/User/188307"
        },
        "body": "some random comment",
        "createdAt": "2025-05-04T09:55:26Z"
      },
      {
        "id": "gid://gitlab/Note/2482861442",
        "author": {
          "id": "gid://gitlab/User/188307"
        },
        "body": "left review comments",
        "createdAt": "2025-05-04T09:55:26Z"
      },
      {
        "id": "gid://gitlab/Note/2483811874",
        "author": {
          "id": "gid://gitlab/User/188307"
        },
        "body": "this is a stand alone comment",
        "createdAt": "2025-05-05T09:15:24Z"
      }
    ]

    reviews = []
    review = []
    lastNote = nil

      # arrays.each_cons(2) do |first, second|
      #   puts "1111111EACH_CONS"
      #   puts first[:createdAt].to_datetime
      #   puts second[:createdAt].to_datetime
      #   diff = second[:createdAt].to_datetime - first[:createdAt].to_datetime
      #   puts diff.to_f
      #   puts diff > 0.001? true : false
      #   puts "2222222222222EACHCONS"
      #   if diff < 0.001
      #     review.push(first)
      #   end
      # end
      # puts review


      arrays.each do |note|
        if lastNote.nil?
          review.push(note)
        elsif note[:createdAt].to_datetime - lastNote[:createdAt].to_datetime < 0.005
          review.push(note)
        else
          reviews.push(review)
          review =[ note ]
        end
        lastNote = note
      end


      reviews.push(review)

      all_array = []

      reviews.each do |review|
        status = []
        remote_node_text = []
        comment_remote_node_id = []
        remote_node_id = []

        review.each do |note|
          remote_node_id.push(note[:id][/\d+$/])
          if note[:body] == "approved this merge request"
            status = "approved"
          elsif note[:body] == "left review comments"
            status = "commented"
          elsif note[:id].include?("DiffNote")
            remote_node_text = note[:body]
            comment_remote_node_id = note[:id][/\d+$/]

          end
        end

        all_array.push(
          {
            status: status,
            remote_node_id: "#{remote_node_id.first}--#{remote_node_id.last}",
            review_comments: [ {
              remote_node_id: comment_remote_node_id,
              remote_node_text: remote_node_text
            } ]
          }
        )
      end

      puts "++++++"
      puts all_array
      puts "+++++++"
  end
end
