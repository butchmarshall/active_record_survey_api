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
					@answer.update_attributes(answer_params[:answer])

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
		
				def create
					@answer = new_answer(answer_params)
					@question.build_answer(@answer, @survey)
					@survey.save

					render json: serialize_model(@answer, serializer: ActiveRecordSurveyApi::AnswerSerializer)
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
						klass = "::ActiveRecordSurvey::Node::Answer::#{(params[:type] || "answer").to_s.camelize}".constantize

						klass.new(params[:answer])
					end

					def json_params
						ActionController::Parameters.new(JSON.parse(request.body.read))
					end

					def answer_params
						json_params.permit(:type, answer: [:text, nodes: []])
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