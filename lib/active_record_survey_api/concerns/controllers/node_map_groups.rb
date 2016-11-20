module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module NodeMapGroups
				extend ActiveSupport::Concern

				def create
					@node_map_group = new_node_map_group
					@node_map_group.survey = @survey
					@node_map_group.attributes = node_map_group_params

					if !@node_map_group.save
						render json: JSONAPI::Serializer.serialize_errors(@node_map_group.errors), :status => 409
					else
						render json: serialize_model(@node_map_group, serializer: ActiveRecordSurveyApi::NodeMapGroupSerializer)
					end
				end

				def all_node_map_groups
					@survey.node_map_groups
				end

				def node_map_group_by_id(id)
					ActiveRecordSurvey::NodeMapGroup.find(id)
				end

				def new_node_map_group(p = nil)
					ActiveRecordSurvey::NodeMapGroup.new(p)
				end

				def json_params
					ActionController::Parameters.new(JSON.parse(request.body.read))
				end

				def node_map_group_params
					json_params.require(:node_map_group).permit(:text, questions: []).tap { |whitelisted|
						whitelisted[:build_from_questions] = whitelisted[:questions] unless whitelisted[:questions].nil?

						whitelisted.delete(:questions)
					}
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