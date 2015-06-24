class QuestionsController < ApplicationController
# skip_before_action :authenticate_user!, only: [:index]
  
  def index
    @questions = Question.all
    @question = Question.new
  end

  def show
    @question = Question.find params[:id]
    @answers = @question.answers
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def create
    question_params = params[:question]
    @question = current_user.questions.new(
      title: question_params[:title],
      description: question_params[:description]
    )
    if @question.save
      # redirect_to i
      redirect_to question_path(@question), notice: "Question created"
    else
      # redisplay form with errors
      render :index
    end
  end
end
