angular = require "angular"
require "./../bower_components/angular-translate/angular-translate"
require "./../bower_components/angular-ui-router/release/angular-ui-router"

require "./register"
require "./functions"

angular.module "mzdos", [
  "mzdos.registers"
  "mzdos.functions"
  "pascalprecht.translate"
  "ui.router"
]

.config ["$translateProvider",($translateProvider)->
  $translateProvider.preferredLanguage "cz"
]

.config ["$stateProvider",($stateProvider)->
  $stateProvider.state("app"
    url: '/'
    abstract: true,
    template: '<div>
      <div ui-view="menu"></div>
      <div ui-view="content"></div>
      </div>'
    views:
      'menu':
        template: require './menu.html'
      'content':
        template:'<div id="fullscreen">
        <div class="center" id="intro">HELLO</div>
        <div>'
  )
]

.controller "menuCtrl",["$scope","menuRegister",($scope,menu)->
  $scope.menu = menu

]