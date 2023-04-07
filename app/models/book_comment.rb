class BookComment < ApplicationRecord
  # userとbookに帰属している
  belongs_to :user
  belongs_to :book
  
end
