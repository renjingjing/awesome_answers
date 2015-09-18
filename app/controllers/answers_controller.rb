class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
        @question        = Question.friendly.find params[:question_id]
        # @answer  = @question.answers.new(answer_params)
        @answer          = Answer.new answer_params
        @answer.question = @question
        @answer.user     = current_user
        respond_to do |format|
        if @answer.save
          AnswersMailer.delay(run_at: 5.minutes.from_now).notify_question_owner(@answer)
          format.html {redirect_to question_path(@question), notice:"Answer created!"}
          # format.js   {render js:"alert('answer saved correctly!');"}
          format.js   {render :create_success}
          # redirect_to question_path(@question), notice: "Answer created!"
        else
          flash[:alert] = "Answer wasn't created"
          # this will render show.html.erb within questions folder (in views)
          # we're choosing to use "render" in here because we want to display
          # the errors resulting from unsuccessful save of @answer. The errors
          # are attached to the @answer object and can be accessed in:
          # @answer.errors
          # using redirect makes a whole new request cycles so we lose the @answer
          # object
          # render "/questions/show"
          format.html do
            flash[:alert] = "Answer can't create!"
            render "question/show"
            end
          format.js   {render :create_failure}
        end
    end
  end
# comment
  def destroy
    @answer   = Answer.find params[:id]
    @question = Question.friendly.find params[:question_id]
    @answer.destroy
    # redirect_to question_path(@question), notice: "Answer deleted."
    respond_to do |format|
      format.html { redirect_to questions_path(@question), notice: "Answer deleted"}
      format.js   { render :destroy}
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
