require_dependency "active_record_survey_api/application_controller"

module Concerns
	module Controllers
		module Instances
			extend ActiveRecordSurveyApi::Concerns::Controllers::Instances
		end
	end
end

module ActiveRecordSurveyApi
	class InstancesController < ApplicationController
		include Concerns::Controllers::Instances

		def show
			@instance = instance_by_id(params[:id])

			render json: @instance, serializer: InstanceSerializer
		end

		def create
			@instance = new_instance(instance_params)
			@instance.save

			render json: @instance, serializer: InstanceSerializer
		end

		def update
			@instance = instance_by_id(params[:id])

			update_instance_params = instance_params[:instance]

			# TODO (maybe)
			# Move this somewhere thats configurable.  But should it be?  Won't work properly without this...

			# Taking survey with this update - wipe previous entries
			if update_instance_params[:instance_nodes_attributes].length > 0
				@instance.instance_nodes.each { |i|
					i.mark_for_destruction
				}
			end

			@instance.update_attributes(update_instance_params)

			render json: @instance, serializer: InstanceSerializer
		end
	end
end
