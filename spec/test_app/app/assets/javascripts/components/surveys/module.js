var surveysModule = angular.module("testApp.Surveys", []);

surveysModule.config(
	function($stateProvider, $urlRouterProvider) {
		var resolve = {
		};

		// Surveys
		$stateProvider.state({
			name: "surveys",
			url: "/surveys",
			templateUrl: 'assets/components/surveys/SurveysView.html',
			controller: 'SurveysController',
			resolve: resolve
		})
		// Survey Questions
		.state({
			name: "surveys.questions",
			url: "/{surveyId:int}/questions",
			templateUrl: 'assets/components/surveys/SurveyQuestionsView.html',
			controller: 'SurveyQuestionsController',
			resolve: {/*
				category: ['$stateParams', 'Api', 'categories', function($stateParams, Api, categories) {
					
				}]*/
			}
		})
	}
);

surveysModule.controller('SurveysController', ['$scope', '$rootScope', '$state', '$location', '$modal', 'ApiAdapter', 'Survey', SurveysController]);
surveysModule.controller('SurveyQuestionsController', ['$scope', '$rootScope', '$state', '$location', '$modal', '$stateParams', 'ApiAdapter', 'Survey', 'Question', SurveyQuestionsController]);