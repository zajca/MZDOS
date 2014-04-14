angular = require "angular"
require "./../bower_components/angular-translate/angular-translate"
require "./../bower_components/angular-ui-router/release/angular-ui-router"

require "./register"
require "./functions"

angular.module("mzdos", [
  "mzdos.registers"
  "mzdos.functions"
])
.config "$translateProvider",($translateProvider)->
  $translateProvider.preferredLanguage "cz"