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

			@instance.update_attributes(instance_params[:instance])

puts "----------- Any errors?"
puts @instance.errors.inspect
			render json: @instance, serializer: InstanceSerializer
		end
	end
end
