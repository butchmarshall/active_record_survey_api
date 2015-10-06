module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Questions
				extend ActiveSupport::Concern

				def all_questions
					ActiveRecordSurvey::Node::Question.all
				end

				def question_by_id(id)
					ActiveRecordSurvey::Node::Question.find(id)
				end

				def new_question(params)
					ActiveRecordSurvey::Node::Question.new(question_params)
				end

				def json_params
					ActionController::Parameters.new(JSON.parse(request.body.read))
				end

				def question_params
					json_params.require(:question).permit(:text, nodes: [])
				end

				included do
					before_filter :find_survey
				end

				def find_survey
					self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
				end
			end
		end
	end
end