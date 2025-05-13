class ArrayController < ApplicationController
  def index
    result = update_diff_note_reviews_map
    p result
    render json: result
  end

  def final_result
    final_result = [
      sorting_diffs,
      discussion_notes_reviews_map,
      one_note_mapping
    ]
  end

  def sorting_diffs
    update_diff_note_reviews_map.map do |note|
      {
        body: nil,
        summary: note[:summary],
        status: note[:status],
        remote_node_id: "",
        review_comments: note[:review_comments]
      }
    end
  end

  def update_diff_note_reviews_map
    t_notes = []
    diff_notes_reviews.map do |review|
      t_notes = review.map do |note|
        id = note[:id]
        if id.include?("DiffNote")
          { remote_node_id: id, comment: note[:body] }
        elsif [ "left review comments", "requested changes", "approved changes" ].include?(note[:body])
          { status: note[:body] }
        else
          note[:body]
        end
      end
      partial_review = {
        review_comments: t_notes.filter { |element| element.class == Hash && element.key?(:comment) },
        summary: t_notes.find { |element| element.class == String }
      }

      status_hash = t_notes.find { |element| element.class == Hash && element.key?(:status) }

      review = partial_review.merge(status_hash)
      binding.pry
    end


    # t_notes
  end

  def diff_note_reviews_map
    diff_note_reviews_map = []
    status = []
    rest = []
    body = ""
    review_comments = []

    diff_notes_reviews.each do |review|
      review.each do |note|
        if note[:id].include?("Note") && !note[:id].include?("DiffNote")
          if note[:body].include?("approved this merge request")
            status = "approved"
          elsif note[:body].include?("left review comments")
            status = "commented"
          elsif note[:body].include?("requested changes")
            status = "requested changes"
          else
            body = note[:body]
          end
        end

          if note[:id].include?("Note")
            body += "#{note[:body]}---"
          end

        if note[:id].include?("DiffNote")
          review_comments.push(
            {
              remote_node_id: note[:id][/\d+$/].to_i,
              comment: note[:body]
            }
          )
        end
      end
      diff_note_reviews_map.push(
        {
          body: body,
          status: status,
          remote_node_id: "",
          review_comments:  review_comments
        }
      )
      review_comments = []
      rest = []
      body = ""
    end
    diff_note_reviews_map
  end

  def discussion_notes_reviews_map
    discussion_notes_reviews_map = []
    status = []
    all_bodies = ""
    discussion_notes_reviews.each do |review|
      body_accum = ""
      review.each do |note|
        if note[:body].include?("approved this merge request")
          status = "approved"
        elsif note[:body].include?("left review comments")
          status = "commented"
        end
        string = "#{note[:body]}---managerbot---"
        body_accum += string
      end
      all_bodies = body_accum
      discussion_notes_reviews_map.push(
        {
        body: all_bodies,
        status: status,
        remote_node_id: "",
        review_comments: []
        }
      )
    end
    discussion_notes_reviews_map
  end

  def discussion_notes_reviews
    discussion_notes_reviews = []
    review_with_many_notes.each do |review|
      review.each do |note|
        if note[:id].include?("DiscussionNote")
          discussion_notes_reviews.push(
            review
          )
        end
      end
    end
    discussion_notes_reviews
  end

  def diff_notes_reviews
    diff_note_reviews = []
    review_with_many_notes.each do |review|
      review.each do |note|
        if note[:id].include?("DiffNote")
          diff_note_reviews.push(
            review
          )
        end
      end
    end
    diff_note_reviews
  end

  def one_note_mapping
    one_note_mapping = []
    review_with_one_note.each do |review|
      review.each do |note|
        if note[:id].include?("DiffNote")
          one_note_mapping.push(
            {
              body: nil,
              status: "commented",
              remote_node_id: note[:id][/\d+$/].to_i,
              review_comment: [ {
                remote_node_id: note[:id][/\d+$/].to_i,
                body: note[:body]
              } ]
            }
          )
        else
          one_note_mapping.push(
            {
              body: note[:body],
              status: "commented",
              remote_node_id: note[:id][/\d+$/].to_i,
              review_comment: nil
            }
          )
        end
      end
    end
    one_note_mapping
  end

  def review_with_many_notes
    review_with_many_notes = []
    array = notes_to_reviews(notes_data)
    array.each do |review|
      if review.count > 1
        review_with_many_notes.push(review)
      end
    end
    review_with_many_notes
  end

  def review_with_one_note
    review_with_one_note = []
    reviews = notes_to_reviews(notes_data)
    reviews.each do |review|
      if review.count == 1
        review_with_one_note.push(review)
      end
    end
    review_with_one_note
  end

  def notes_to_reviews(data)
    notes = data
    lastNote = nil
    review = []
    reviews = []
    notes.each do |note|
      if lastNote.nil?
        review.push(note)
      elsif note[:createdAt].to_time - lastNote[:createdAt].to_time < 1
        review.push(note)
      else
        reviews.push(review)
        review = []
        review.push(note)
      end
      lastNote = note
    end
    reviews.push(review)
    reviews
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
