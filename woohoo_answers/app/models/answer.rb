class Answer < ActiveRecord::Base
  belongs_to :question, :user
  validates_presence_of :question_id, :description
end
