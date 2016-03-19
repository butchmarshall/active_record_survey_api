module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Questions
				extend ActiveSupport::Concern

				included do
					before_filter :find_survey, :if => proc { |c| params[:survey_id].to_i > 0 }
				end

				def index
					@questions = all_questions

					render json: serialize_models(@questions, serializer: ActiveRecordSurveyApi::QuestionSerializer, meta: { total: @questions.length })
				end

				def show
					@question = question_by_id(params[:id])

					render json: serialize_model(@question, serializer: ActiveRecordSurveyApi::QuestionSerializer)
				end

				def destroy
					@question = question_by_id(params[:id])
					@question.destroy

					head :no_content
				end

				def update
					@question = question_by_id(params[:id])
					@question.update_attributes(question_params)

					render json: serialize_model(@question, serializer: ActiveRecordSurveyApi::QuestionSerializer)
				end

				def create
					@question = new_question(question_params)
					@question.survey = @survey
					@question.save

					render json: serialize_model(@question, serializer: ActiveRecordSurveyApi::QuestionSerializer)
				end

				private
					def all_questions
						all_questions = []
						all_questions = @survey.questions if !@survey.nil?
						all_questions
					end

					def question_by_id(id)
						ActiveRecordSurvey::Node::Question.find(id)
					end

					def new_question(params)
						ActiveRecordSurvey::Node::Question.new(params, :survey => @survey)
					end

					def json_params
						ActionController::Parameters.new(JSON.parse(request.body.read))
					end

					def question_params
						json_params.require(:question).require(:attributes).permit(:text)
					end

					def find_survey
						self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
					end
			end
		end
	end
end