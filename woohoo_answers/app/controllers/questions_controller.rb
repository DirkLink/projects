class QuestionsController < ApplicationController
  def index
    @questions = Question.all
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
    @question = Question.new(
      title: question_params[:title],
      description: question_params[:description]
    )
    if @question.save
      # redirect_to i
      redirect_to question_path(@question), notice: "Question created"
    else
      # redisplay form with errors
      render :new
    end
  end
end
