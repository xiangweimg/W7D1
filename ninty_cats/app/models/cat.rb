require "action_view"
require "date"

# == Schema Information
#
# Table name: cats
#
#  id          :bigint           not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Cat < ApplicationRecord
    
    include ActionView::Helpers::DateHelper

    CAT_COLORS = ["Orange", "White", "Blue", "Black","Tabby", "Tri-Color"]
    validates :birth_date, :name, presence: true
    validates :color, inclusion: { in: CAT_COLORS}
    validates :sex, inclusion: {in: ["F", "M"]}
    validate :birth_date_cannot_be_future
    
    def birth_date_cannot_be_future
        if self.birth_date > Date.today
            errors.add(:birth_date, "can't be in the future")
        end
    end 

    def age
        time_ago_in_words(birth_date)
    end


end
