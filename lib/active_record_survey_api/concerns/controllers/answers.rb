module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Answers
				extend ActiveSupport::Concern

				def all_answers
					Answer.all
				end

				def answer_by_id(id)
					Answer.find(id)
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

				included do
					before_filter :find_survey
					before_filter :find_question
				end

				def find_survey
					self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
				end

				def find_question
					self.instance_variable_set "@question", ActiveRecordSurvey::Node::Question.find(params[:question_id])
				end
			end
		end
	end
end