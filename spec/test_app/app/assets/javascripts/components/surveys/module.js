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
		});
	}
);

surveysModule.controller('SurveysController', ['$scope', '$rootScope', '$state', '$location', '$modal', 'ApiAdapter', 'Survey', SurveysController]);