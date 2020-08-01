class Rip < ApplicationRecord
    validates :product_id, uniqueness: true
end
