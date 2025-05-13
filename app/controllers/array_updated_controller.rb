class ArrayUpdatedController < ApplicationController
  def index
    result = time_map_reviews
    render json: result
  end

  def cutcopy
    reviews = time_map_reviews
    cut(reviews)
  end

  def cut(reviews)
    reviews.map do |review|
      copy(review)
    end
  end

  def copy(review)
    t_note = review.map do |note|
      id = note[:id]
      if id.include?("DiffNote")
       { remote_node_id: id, comment: note[:body] }
      elsif id.include?("DiscussionNote")
        { remote_node_id: id, discussion_comment: note[:body] }
      elsif [ "left review comments", "approved this merge request", "requested changes" ].include?(note[:body])
        { status: note[:body] }
      else
        note[:body]
      end
    end

    partial_review = {
      status: t_note.find { |el| el.is_a?(Hash) && el.key?(:status) }&.dig(:status),
      summary: t_note.find { |el| el.class == String }
    }

    review_comment_hash = {
      review_comments: t_note.filter { |el| el.class == Hash && el.key?(:comment) }
    }

    discussion_comment_hash = {
      discussion_comment: t_note.filter { |el| el.class == Hash && el.key?(:discussion_comment) }
    }

    final_review = partial_review.merge(review_comment_hash).merge(discussion_comment_hash)
  end

  def discussion_review
    time_map_reviews.filter { |el| el.first[:id].include?("DiscussionNote") }
  end

  def time_map_reviews
    reviews = []
    review = []
    lastNote = nil
    notes_data.map do |note|
      if lastNote.nil?
        review << note
      elsif note[:createdAt].to_time - lastNote[:createdAt].to_time < 0.1
        review << note
      else
        reviews << review
        review = [ note ]
      end
      lastNote = note
    end
    reviews
  end

  def short_notes_data
    notes = [
      {
        "id": "gid://gitlab/DiffNote/2490690130",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "This is diff 1 or review 5",
        "createdAt": "2025-05-07T17:39:47Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2490690170",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is diff 2 of review 5",
        "createdAt": "2025-05-07T17:39:47Z"
      },
      {
        "id": "gid://gitlab/Note/2490690229",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is summary comment of review 5",
        "createdAt": "2025-05-07T17:39:47Z"
      },
      {
        "id": "gid://gitlab/Note/2490690242",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "left review comments",
        "createdAt": "2025-05-07T17:39:47Z"
      }
    ]
  end

  def notes_data
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
      },
      {
        "id": "gid://gitlab/DiffNote/2490673073",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this should be another diff in review 3",
        "createdAt": "2025-05-07T17:28:31Z"
      },
      {
        "id": "gid://gitlab/Note/2490673082",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "requested changes",
        "createdAt": "2025-05-07T17:28:31Z"
      },
      {
        "id": "gid://gitlab/DiscussionNote/2490676134",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is comment 1 of review 4",
        "createdAt": "2025-05-07T17:30:46Z"
      },
      {
        "id": "gid://gitlab/DiscussionNote/2490676141",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is comment 2 of review 4",
        "createdAt": "2025-05-07T17:30:46Z"
      },
      {
        "id": "gid://gitlab/Note/2490676156",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "left review comments",
        "createdAt": "2025-05-07T17:30:46Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2490678384",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is a diff outside of a review",
        "createdAt": "2025-05-07T17:32:13Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2490690130",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "This is diff 1 or review 5",
        "createdAt": "2025-05-07T17:39:47Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2490690170",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is diff 2 of review 5",
        "createdAt": "2025-05-07T17:39:47Z"
      },
      {
        "id": "gid://gitlab/Note/2490690229",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is summary comment of review 5",
        "createdAt": "2025-05-07T17:39:47Z"
      },
      {
        "id": "gid://gitlab/Note/2490690242",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "left review comments",
        "createdAt": "2025-05-07T17:39:47Z"
      },
      {
        "id": "gid://gitlab/Note/2490694874",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is comment 1 outside of review",
        "createdAt": "2025-05-07T17:42:58Z"
      },
      {
        "id": "gid://gitlab/Note/2490695132",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is comment 2 outside of review",
        "createdAt": "2025-05-07T17:43:10Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2490695774",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is diff 1 outside of review",
        "createdAt": "2025-05-07T17:43:41Z"
      },
      {
        "id": "gid://gitlab/DiffNote/2490696279",
        "author": {
          "id": "gid://gitlab/User/26776724"
        },
        "body": "this is diff 2 outside of review",
        "createdAt": "2025-05-07T17:44:02Z"
      }
    ]
  end
end
