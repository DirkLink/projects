class AnswersController < ApplicationController
  def create
    answer_params = params[:answer]
    @answer = current_user.answers.new(
      question_id: answer_params[:question_id],
      description: answer_params[:description]
    )
    if @answer.save
      question = Question.find(answer_params[:question_id])
      # redirect_to i
      redirect_to question_path(question), notice: "Answer created"
    else
      # redisplay form with errors
      render :new
    end
  end
end
