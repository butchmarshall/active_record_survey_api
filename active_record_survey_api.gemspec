$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_record_survey_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
	spec.name        = "active_record_survey_api"
	spec.version     = ActiveRecordSurveyApi::VERSION
	spec.authors     = ["Butch Marshall"]
	spec.email       = ["butch.a.marshall@gmail.com"]
	spec.homepage    = "https://github.com/butchmarshall/active_record_survey_api"
	spec.summary     = "API implementation for ActiveRecordSurvey."
	spec.description = "A minimalist API implementation for ActiveRecordSurvey.  You take care of the details."
	spec.license     = "MIT"

	spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
	spec.test_files = Dir["spec/**/*"]

	spec.add_dependency "rails", "~> 4.2.4"
	#spec.add_dependency "active_model_serializers" , "0.10.2"
	spec.add_dependency "jsonapi-serializers"
	spec.add_dependency "active_record_survey", ">= 0.1.47"
	spec.add_dependency "active_record_survey-node_map_group", ">= 0.0.4"
	spec.add_dependency "globalize", "> 4"
	spec.add_dependency "http_accept_language"

	if RUBY_PLATFORM == 'java'
		spec.add_development_dependency "jdbc-sqlite3", "> 0"
		spec.add_development_dependency "activerecord-jdbcsqlite3-adapter", "> 0"
	else
		spec.add_development_dependency "sqlite3", "> 0"
	end

	spec.add_development_dependency "rspec-rails"
	spec.add_development_dependency "factory_girl_rails"
	spec.add_development_dependency "capybara"
	spec.add_development_dependency "database_cleaner"
	spec.add_development_dependency "rack-cors"
	spec.add_development_dependency "angular-ui-bootstrap-rails"
end