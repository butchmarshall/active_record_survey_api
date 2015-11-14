module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Instances
				extend ActiveSupport::Concern
	
				included do
					before_filter :find_survey, :if => proc { |c| params[:survey_id].to_i > 0 }
				end

				def show
					@instance = instance_by_id(params[:id])

					render json: serialize_model(@instance, serializer: ActiveRecordSurveyApi::InstanceSerializer)
				end
		
				def create
					@instance = new_instance(instance_params)
					@instance.save

					render json: serialize_model(@instance, serializer: ActiveRecordSurveyApi::InstanceSerializer)
				end
		
				def update
					@instance = instance_by_id(params[:id])
		
					update_instance_params = instance_params[:instance]
		
					# Taking survey with this update - wipe previous entries
					if update_instance_params[:instance_nodes_attributes].length > 0
						@instance.instance_nodes.each { |i|
							i.mark_for_destruction
						}
					end
		
					@instance.update_attributes(update_instance_params)

					render json: serialize_model(@instance, serializer: ActiveRecordSurveyApi::InstanceSerializer)
				end

				private
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

					def find_survey
						self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
					end
			end
		end
	end
end