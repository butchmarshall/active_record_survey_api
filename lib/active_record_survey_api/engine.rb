module ActiveRecordSurveyApi
	class Engine < ::Rails::Engine
		isolate_namespace ActiveRecordSurveyApi

		config.generators do |g|
			g.test_framework :rspec
			g.fixture_replacement :factory_girl, :dir => 'spec/factories'
			g.assets false
			g.helper false
		end
	end
end