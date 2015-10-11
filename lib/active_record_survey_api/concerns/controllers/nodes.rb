module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Nodes
				extend ActiveSupport::Concern

				def all_nodes
					@survey.nodes
				end

				def node_by_id(id)
					ActiveRecordSurvey::Node.find(id)
				end

				def new_node(params)
					ActiveRecordSurvey::Node.new(node_params)
				end

				def json_params
					ActionController::Parameters.new(JSON.parse(request.body.read))
				end

				def node_params
					json_params.require(:node).permit(:text, nodes: [])
				end

				included do
					before_filter :find_survey, :if => proc { |c| params[:survey_id].to_i > 0 }
				end

				def find_survey
					self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
				end
			end
		end
	end
end