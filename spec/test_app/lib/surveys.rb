puts "-traaaaaaaaaaaaaaaaaaace 1!!!!!!!!!!!!!!!!!!!!!!!!"

module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Surveys
				extend ActiveSupport::Concern
	
				def all_surveys
					::ActiveRecordSurvey::Survey.where(:id => 1000)
				end
			end
		end
	end
end