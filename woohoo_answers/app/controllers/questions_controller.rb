class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

   def show
    @question = Question.find params[:id]
  end

  def create
    question_params = params[:question]
    @item = Item.new(
      title: question_params[:title],
      description: question_params[:description]
    )
  end
end
