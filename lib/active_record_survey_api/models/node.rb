module ActiveRecordSurveyApi
	module Models
		module Node
			def self.included(base)
				base.class_eval do
					translates :text
				end
			end
		end
	end
end