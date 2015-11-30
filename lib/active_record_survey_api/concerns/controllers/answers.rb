module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Answers
				extend ActiveSupport::Concern

				included do
					before_filter :find_survey, :if => proc { |c| params[:survey_id].to_i > 0 }
					before_filter :find_question, :if => proc { |c| params[:question_id].to_i > 0 }
					before_filter :find_answer, :if => proc { |c| params[:answer_id].to_i > 0 }
				end

				def update
					@answer = answer_by_id(params[:id])
					@answer.update_attributes(answer_params)

					render json: serialize_model(@answer, serializer: ActiveRecordSurveyApi::AnswerSerializer)
				end

				def index
					@answers = all_answers

					render json: serialize_models(@answers, serializer: ActiveRecordSurveyApi::AnswerSerializer, meta: { total: @answers.length })
				end
		
				def show
					@answer = answer_by_id(params[:id])

					render json: serialize_model(@answer, serializer: ActiveRecordSurveyApi::AnswerSerializer)
				end

				def destroy
					@answer = answer_by_id(params[:id])
					@answer.destroy

					head :no_content
				end

				def create
					@survey = @question.survey if @survey.nil?
					@answer = new_answer(answer_params)
					@question.build_answer(@answer, @survey)
					@survey.save

					render json: serialize_model(@answer, serializer: ActiveRecordSurveyApi::AnswerSerializer)
				end

				def get_next_question
					@answer = answer_by_id(params[:answer_id])
					@question = @answer.next_question

					render json: serialize_model(@question, serializer: ActiveRecordSurveyApi::QuestionSerializer)
				end

				def link_next_question
					@answer = answer_by_id(params[:answer_id])
					@question = ActiveRecordSurvey::Node::Question.find(json_params[:question_id])
					@answer.build_link(@question)
					@answer.save

					head :no_content
				end

				def unlink_next_question
					@answer = answer_by_id(params[:answer_id])
					@answer.remove_link
					@answer.save

					head :no_content
				end

				private
					def all_answers
						all_answers = []
						all_answers = @question.answers if !@question.nil?
						all_answers
					end

					def answer_by_id(id)
						ActiveRecordSurvey::Node::Answer.find(id)
					end

					def new_answer(params)
						klass = "#{(params[:type] || "::ActiveRecordSurvey::Node::Answer")}".constantize

						klass.new(params)
					end

					def json_params
						ActionController::Parameters.new(JSON.parse(request.body.read))
					end

					def answer_params
						json_params.require(:answer).require(:attributes).permit(:text,:type).tap { |whitelisted|
							whitelisted[:type] = "ActiveRecordSurvey::Node::Answer::#{whitelisted[:type].camelize}" unless whitelisted[:type].nil?
						}
					end

					def find_survey
						self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
					end

					def find_question
						self.instance_variable_set "@question", ActiveRecordSurvey::Node::Question.find(params[:question_id])
					end

					def find_answer
						self.instance_variable_set "@answer", ActiveRecordSurvey::Node::Answer.find(params[:answer_id])
					end
			end
		end
	end
end