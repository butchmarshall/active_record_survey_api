
testApp.constant('SURVEY_EVENTS', {
	create: 'create',
	update: 'update',
	destroy: 'destroy',
})

testApp.factory('Survey', ['$rootScope', 'SURVEY_EVENTS', 'ApiAdapter',
	function($rootScope, SURVEY_EVENTS, ApiAdapter) {
		ApiAdapter.addRoute(
			"get_surveys",
			"/surveys"
		);
		ApiAdapter.addRoute(
			"get_survey",
			"/surveys/{surveyId}"
		);
		ApiAdapter.addRoute(
			"create_survey",
			"/surveys",
			{
				"type": "POST",
				"processData": false,
				"contentType": "application/json",
				"success": function(result) {
					$rootScope.$broadcast(SURVEY_EVENTS.create, result.response);
				}
			}
		);
		ApiAdapter.addRoute(
			"update_survey",
			"/surveys/{surveyId}",
			{
				"type": "PUT",
				"processData": false,
				"contentType": "application/json",
				"success": function(result) {
					$rootScope.$broadcast(SURVEY_EVENTS.update, result.response);
				}
			}
		);
		ApiAdapter.addRoute(
			"delete_survey",
			"/surveys/{surveyId}",
			{
				"type": "DELETE",
				"success": function(result) {
					$rootScope.$broadcast(SURVEY_EVENTS.destroy, result);
				}
			}
		);
		ApiAdapter.addRoute(
			"get_survey_questions",
			"/surveys/{surveyId}/questions",
			{
				"type": "GET"
			}
		);

		return {
			get: function(params, data, args) {
				args = ((typeof(args) != "object")? {} : args);
				args.noCache = ((typeof(args.noCache) != "boolean")? true : args.noCache);
				return ApiAdapter.execute("get_survey", params, data, args);
			},
			index: function(params, data, args) {
				args = ((typeof(args) != "object")? {} : args);
				args.noCache = ((typeof(args.noCache) != "boolean")? true : args.noCache);
				return ApiAdapter.execute("get_surveys", params, data, args);
			},
			create: function(params, data, args) {
				args = ((typeof(args) != "object")? {} : args);
				args.noCache = ((typeof(args.noCache) != "boolean")? true : args.noCache);
				return ApiAdapter.execute("create_survey", params, data, args);
			},
			update: function(params, data, args) {
				args = ((typeof(args) != "object")? {} : args);
				args.noCache = ((typeof(args.noCache) != "boolean")? true : args.noCache);
				return ApiAdapter.execute("update_survey", params, data, args);
			},
			destroy: function(params, data, args) {
				args = ((typeof(args) != "object")? {} : args);
				args.noCache = ((typeof(args.noCache) != "boolean")? true : args.noCache);
				return ApiAdapter.execute("delete_survey", params, data, args);
			},
			questions: function(params, data, args) {
				args = ((typeof(args) != "object")? {} : args);
				args.noCache = ((typeof(args.noCache) != "boolean")? true : args.noCache);
				return ApiAdapter.execute("get_survey_questions", params, data, args);
			}
		};
	}
]);