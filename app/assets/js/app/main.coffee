# Set up the application
@app = angular.module('RigData', [])

# This is an injectable property
@app.value 'Authentication', {}

# Add a directive so that if we see a csrf-token attribute, this gets set
@app.directive 'csrfToken', (Authentication) ->
  (scope, element, attrs) ->
    Authentication.csrf_token = attrs.csrfToken
