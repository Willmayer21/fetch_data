class Event < ApplicationRecord
  belongs_to :merge_request
  belongs_to :note
end
