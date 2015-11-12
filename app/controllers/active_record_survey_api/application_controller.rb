module ActiveRecordSurveyApi
	class ApplicationController < ActionController::Base
		before_filter :set_locale

		private
			def set_locale
				# If a language is sent - it's the preferred language!
				if !request.headers[:HTTP_ACCEPT_LANGUAGE].to_s.empty?
					http_accept_language.user_preferred_languages = [request.headers[:HTTP_ACCEPT_LANGUAGE].to_s] 
				end

				I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
			end
	end
end
