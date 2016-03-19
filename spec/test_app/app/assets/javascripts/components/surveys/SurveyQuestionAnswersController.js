function SurveyQuestionAnswersController($scope, $rootScope, $state, $location, $modal, $stateParams, $q, ApiAdapter, Survey, Question, Answer) {
	$scope.headers = {
		'Accept-Language': 'en'
	};

	$scope.survey = null;
	Survey.get({
		surveyId: $stateParams.surveyId
	}, {}).then(
		function(result) {
			$scope.survey = result;
			if(!$scope.$$phase) {
				$scope.$apply();
			}
		}
	);

	$scope.questions = null;
	Survey.questions({
		surveyId: $stateParams.surveyId
	}, {}).then(
		function(result) {
			$scope.questions = result;
			if(!$scope.$$phase) {
				$scope.$apply();
			}
		}
	);

	$scope.question = null;
	$scope.answers = {data:[]};
	$scope.$watch("headers['Accept-Language']", function(newValue, oldValue) {
		Question.get({
			questionId: $stateParams.questionId
		}, {}).then(
			function(result) {
				$scope.question = result;
				if(!$scope.$$phase) {
					$scope.$apply();
				}
			}
		);

		Answer.index({
			questionId: $stateParams.questionId
		}, {}, {
			no_cache: true,
			headers: $scope.headers
		}).then(
			function(answers) {
				var deferred = [];
				for(var i = 0; i < answers.data.length; i++) {
					(function(defer) {
						ApiAdapter.execute("get_answer_next_question", answers.data[i]["relationships"]["next-question"]["links"]["self"]).then(
							function (result) {
								defer.resolve(result);
							},
							function(result) {
								defer.reject(result);
							}
						);
						deferred.push(defer.promise);
					})($q.defer());
				}

				$q.allSettled(deferred).then(
					function (next_questions) {
						for(var i = 0; i < next_questions.length; i++) {
							answers.data[i].attributes['next-question-id'] = null;
							if (next_questions[i].state == "fulfilled") {
								console.log(next_questions[i].value);
								answers.data[i].attributes['next-question-id'] = (next_questions[i].value.data)? next_questions[i].value.data.id : next_questions[i].value.data;
							}
						}

						$scope.answers = answers;
						if(!$scope.$$phase) {
							$scope.$apply()
						}
					}
				);
			}
		);
	});

	$scope.$watch("answers.data", function(newValue, oldValue) {
		for(var i  = 0; i < oldValue.length; i++) {
			if (oldValue[i].attributes['next-question-id'] != newValue[i].attributes['next-question-id']) {
				Answer.create_next_question({
					answerId: newValue[i].id
				}, JSON.stringify({
					question_id: newValue[i].attributes['next-question-id']
				}), {
					no_cache: true
				}).then(
					function(response) {
						alert("Success!");
					},
					function (args) {
						alert("Failure!");
					}
				);
				break;
			}
		}
	}, true);

	$scope.answer_delete = function(self_href) {
		ApiAdapter.execute("delete_answer", self_href, {}, true
		).then(
			function(response) {
				$state.go($state.current, {}, {reload: true});
			}
		);
	};

	$scope.answer_edit = function(answer_id) {
		$modal.open({
			size: 'lg',
			resolve: {
				answer: [function($stateParams, Api) {
					return Answer.get({answerId: answer_id});
				}]
			},
			controller: function($scope, $modalInstance, answer) {
				$scope.model = {
					id: answer.data.id,
					answer: {
						attributes: answer.data.attributes
					}
				};

				$scope.onSubmit = function(data) {
					return ApiAdapter.execute("update_answer", {
						answerId: answer_id
					}, JSON.stringify(data), {
						no_cache: true,
						headers: {
							'Accept-Language': data.language
						}
					}).then(
						function(response) {
							$state.go($state.current, {}, {reload: true});
							$modalInstance.close();
							return response;
						}
					);
				};
				$scope.cancel = function() {
					$modalInstance.close();
				};
			},
			templateUrl: "/assets/components/surveys/AnswerModal.html"
		});
	};

	$scope.answer_new = function() {
		$modal.open({
			size: 'lg',
			controller: function($scope, $modalInstance) {
				$scope.model = {
					answer: {
						attributes: {
							text: ""
						}
					}
				};

				$scope.onSubmit = function(data) {
					return ApiAdapter.execute("create_answer", {
						questionId: $stateParams.questionId
					}, JSON.stringify(data), {
						no_cache: true,
						headers: {
							'Accept-Language': data.language
						}
					}).then(
						function(response) {
							$state.go($state.current, {}, {reload: true});
							$modalInstance.close();
							return response;
						}
					);
				};
				$scope.cancel = function() {
					$modalInstance.close();
				};
			},
			templateUrl: "/assets/components/surveys/AnswerModal.html"
		});
	};
};