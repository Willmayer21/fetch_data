class Note < ApplicationRecord
  belongs_to :merge_request
  has_many :events
end
