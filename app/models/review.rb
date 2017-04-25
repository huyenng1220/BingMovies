class Review < ApplicationRecord
	belongs_to :movie, optional: true
	belongs_to :user
	validates :rating, numericality: { less_than_or_equal_to: 10,  only_integer: true }
	validates_presence_of :review
end
