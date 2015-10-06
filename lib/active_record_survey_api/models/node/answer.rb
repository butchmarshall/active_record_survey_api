module ActiveRecordSurveyApi
	module Models
		module Node
			module Answer
				def self.included(base)
					base.class_eval do
						translates :text
					end
				end
			end
		end
	end
end