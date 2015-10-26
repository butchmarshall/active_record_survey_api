require_dependency "active_record_survey_api/application_controller"

module Concerns
	module Controllers
		module InstanceNodes
			extend ActiveRecordSurveyApi::Concerns::Controllers::InstanceNodes
		end
	end
end

module ActiveRecordSurveyApi
	class InstanceNodesController < ApplicationController
		include Concerns::Controllers::InstanceNodes

		def show
			@instance_node = instance_node_by_id(params[:id])

			render json: @instance_node, serializer: InstanceNodeSerializer
		end

		def create
			@instance_node = new_instance_node(instance_node_params.merge(:instance => @instance))
			@instance_node.save

			render json: @instance_node, serializer: InstanceNodeSerializer
		end
	end
end
