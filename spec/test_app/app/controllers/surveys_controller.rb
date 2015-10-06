
module Concerns
	module Controllers
		module Surveys
			extend ActiveRecordSurveyApi::Concerns::Controllers::Surveys

			# Extends engine functionality
			def all_surveys
				super
			end
		end
	end
end

class SurveysController < ::ActiveRecordSurvey::SurveysController
	include Concerns::Controllers::Surveys
end