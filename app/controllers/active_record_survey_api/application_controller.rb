module ActiveRecordSurveyApi
	class ApplicationController < ActionController::Base
		before_filter :set_locale

		def serialize_model(model, options = {})
			options[:is_collection] = false
			((options[:serializer]) ? options[:serializer] : JSONAPI::Serializer).serialize(model, options)
		end

		def serialize_models(models, options = {})
			options[:is_collection] = true
			((options[:serializer]) ? options[:serializer] : JSONAPI::Serializer).serialize(models, options)
		end

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
