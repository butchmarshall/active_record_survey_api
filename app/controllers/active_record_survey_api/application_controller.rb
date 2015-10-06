module ActiveRecordSurveyApi
	class ApplicationController < ActionController::Base
		include HttpAcceptLanguage::AutoLocale
	end
end
