class Music < ActiveRecord::Base
  belongs_to :Category
  belongs_to :User
end
