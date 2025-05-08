class ArrayController < ApplicationController
  def index
    notes = [
      {
        "id": "gid://gitlab/DiscussionNote/2490666654",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is the start of the review",
        "createdAt": "2025-05-07T17:24:36Z"
      },
      {
        "id": "gid://gitlab/DiscussionNote/2490666659",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is a comment in the review created",
        "createdAt": "2025-05-07T17:24:36Z"
      },
      {
        "id": "gid://gitlab/Note/2490666662",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "approved this merge request",
        "createdAt": "2025-05-07T17:24:36Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2490669031",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is the start of review 2",
        "createdAt": "2025-05-07T17:25:39Z"
      },
      {
        "id": "gid://gitlab/Note/2490669042",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "requested changes",
        "createdAt": "2025-05-07T17:25:39Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2490673069",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is start of review 3",
        "createdAt": "2025-05-07T17:28:31Z"
      }
      # {
      #   "id": "gid://gitlab/DiffNote/2490673073",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this should be another diff in review 3",
      #   "createdAt": "2025-05-07T17:28:31Z"
      # },
      # {
      #   "id": "gid://gitlab/Note/2490673082",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "requested changes",
      #   "createdAt": "2025-05-07T17:28:31Z"
      # },
      # {
      #   "id": "gid://gitlab/DiscussionNote/2490676134",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is comment 1 of review 4",
      #   "createdAt": "2025-05-07T17:30:46Z"
      # },
      # {
      #   "id": "gid://gitlab/DiscussionNote/2490676141",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is comment 2 of review 4",
      #   "createdAt": "2025-05-07T17:30:46Z"
      # },
      # {
      #   "id": "gid://gitlab/Note/2490676156",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "left review comments",
      #   "createdAt": "2025-05-07T17:30:46Z"
      # },
      # {
      #   "id": "gid://gitlab/DiffNote/2490678384",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is a diff outside of a review",
      #   "createdAt": "2025-05-07T17:32:13Z"
      # },
      # {
      #   "id": "gid://gitlab/DiffNote/2490690130",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "This is diff 1 or review 5",
      #   "createdAt": "2025-05-07T17:39:47Z"
      # },
      # {
      #   "id": "gid://gitlab/DiffNote/2490690170",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is diff 2 of review 5",
      #   "createdAt": "2025-05-07T17:39:47Z"
      # },
      # {
      #   "id": "gid://gitlab/Note/2490690229",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is summary comment of review 5",
      #   "createdAt": "2025-05-07T17:39:47Z"
      # },
      # {
      #   "id": "gid://gitlab/Note/2490690242",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "left review comments",
      #   "createdAt": "2025-05-07T17:39:47Z"
      # },
      # {
      #   "id": "gid://gitlab/Note/2490694874",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is comment 1 outside of review",
      #   "createdAt": "2025-05-07T17:42:58Z"
      # },
      # {
      #   "id": "gid://gitlab/Note/2490695132",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is comment 2 outside of review",
      #   "createdAt": "2025-05-07T17:43:10Z"
      # },
      # {
      #   "id": "gid://gitlab/DiffNote/2490695774",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is diff 1 outside of review",
      #   "createdAt": "2025-05-07T17:43:41Z"
      # },
      # {
      #   "id": "gid://gitlab/DiffNote/2490696279",
      #   "author": {
      #     "id": "gid://gitlab/User/26776724"
      #   },
      #   "body": "this is diff 2 outside of review",
      #   "createdAt": "2025-05-07T17:44:02Z"
      # }
    ]
   # reviews = []
   # review = []
   # last_note = nil

   # notes.each do |note|
   #   if last_note.nil?
   #     review << note
   #   elsif (note[:createdAt].to_time - last_note[:createdAt].to_time).abs < 1
   #     review << note
   #   else
   #     reviews.push([ review ])
   #     review = [ note ]
   #   end
   #   last_note = note
   # end

   # reviews << review unless review.empty?


   jo = [
      {
        "createdAt": "2025-05-07T17:24:36Z",
        "number": 1
      },
      {
        "createdAt": "2025-05-07T17:24:36Z",
        "number": 2
      },
      {
        "createdAt": "2025-05-07T17:24:36Z",
        "number": 3
      },
      {
        "createdAt": "2025-05-07T17:25:39Z",
        "number": 4
      },
      {
        "createdAt": "2025-05-07T17:25:39Z",
        "number": 5
      }
    ]

# puts jo

lastNote = nil
review = []
reviews = []

jo.each do |note|
  if lastNote.nil?
    review.push(note)
    puts "lastNote nil - this is #{review}"
  elsif note[:createdAt].to_time - lastNote[:createdAt].to_time < 1
    review.push(note)
    puts "<1 --- review:#{review}"
  else
    reviews.push(review)
    review = []
    review.push(note)
    puts "else ---- review:#{review}"
  end
  lastNote = note
end
reviews.push(review)
p reviews
p "\\\\\\\\\\\\\\\\\\\\\\\\"
review = []
reviews = []
jack = [ 1, 2, 3 ]
review.push(jo[0])
review.push(jo[1])
review.push(jo[2])
p jack
p review
p "11111111"
reviews.push(review)
review = [ jo[3] ]
p review
p reviews
p "222222222"
review.push(jo[4])
reviews.push(review)

p reviews
p "---------"
p review

    # reviews.push(review)

    # puts reviews

    # all_array = []

    # reviews.each do |review|
    #   status = []
    #   remote_node_text = []
    #   comment_remote_node_id = []
    #   remote_node_id = []

    #   review.each do |note|
    #     remote_node_id.push(note[:id][/\d+$/])
    #     if note[:body] == "approved this merge request"
    #       status = "approved"
    #     elsif note[:body] == "left review comments"
    #       status = "commented"
    #     elsif note[:id].include?("DiffNote")
    #       remote_node_text = note[:body]
    #       comment_remote_node_id = note[:id][/\d+$/]
    #     end
    #   end

    #   all_array.push(
    #     {
    #       status: status,
    #       remote_node_id: "#{remote_node_id.first}--#{remote_node_id.last}",
    #       review_comments: [ {
    #         remote_node_id: comment_remote_node_id,
    #         remote_node_text: remote_node_text
    #       } ]
    #     }
    #   )
    # end

    # puts "++++++"
    # puts all_array
    # puts "+++++++"
  end
end
