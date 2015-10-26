module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Instances
				extend ActiveSupport::Concern

				def instance_by_id(id)
					ActiveRecordSurvey::Instance.find(id)
				end

				def new_instance(params)
					instance = ActiveRecordSurvey::Instance.new(instance_params)
					instance.survey = @survey
					instance
				end

				def json_params
					i = {}
					begin
						i = JSON.parse(request.body.read)
					rescue Exception => $e
					end

					ActionController::Parameters.new(i)
				end

				def instance_params
					json_params.permit(instance: [instance_nodes_attributes: [:active_record_survey_node_id]]).tap { |i|
						if i[:instance] && i[:instance][:instance_nodes_attributes]
							i[:instance][:instance_nodes_attributes].map { |j|
								# Needed or validation will fail - issue with active_record_survey implementation
								j[:instance] = @instance
								j[:instance]
							}
						end
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