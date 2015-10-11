module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module NodeMaps
				extend ActiveSupport::Concern

				def all_node_maps
					@survey.node_maps
				end

				def node_map_by_id(id)
					ActiveRecordSurvey::NodeMap.find(id)
				end

				def new_node_map(params)
					ActiveRecordSurvey::NodeMap.new(node_map_params)
				end

				def json_params
					ActionController::Parameters.new(JSON.parse(request.body.read))
				end

				def node_map_params
					json_params.require(:node_map).permit(:text, nodes: [])
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