module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module InstanceNodes
				extend ActiveSupport::Concern

				included do
					before_filter :find_survey, :if => proc { |c| params[:survey_id].to_i > 0 }
					before_filter :find_instance, :if => proc { |c| params[:instance_id].to_i > 0 }
				end

				def show
					@instance_node = instance_node_by_id(params[:id])

					render json: serialize_model(@instance_node, serializer: ActiveRecordSurveyApi::InstanceNodeSerializer)
				end

				def destroy
					@instance_node = instance_node_by_id(params[:id])
					@instance_node.destroy

					head :no_content
				end

				def create
					@instance_node = new_instance_node(instance_node_params.merge(:instance => @instance))
					@instance_node.save

					render json: serialize_model(@instance_node, serializer: ActiveRecordSurveyApi::InstanceNodeSerializer)
				end

				private
					def instance_node_by_id(id)
						ActiveRecordSurvey::Instance.find(id)
					end

					def new_instance_node(params)
						# DRAGONS!
						# This doesn't work properly unless params has key :instance with proper object passed
						# Because of active_record_survey validate method in how it determines INVALID_PATH
						@instance.instance_nodes.build(params)
					end

					def json_params
						i = {}
						begin
							i = JSON.parse(request.body.read)
						rescue Exception => $e
						end

						ActionController::Parameters.new(i)
					end

					def instance_node_params
						json_params.require(:instance_node).permit(:active_record_survey_node_id)
					end

					def find_survey
						self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
					end

					def find_instance
						self.instance_variable_set "@instance", ActiveRecordSurvey::Instance.find(params[:instance_id])
					end
			end
		end
	end
end