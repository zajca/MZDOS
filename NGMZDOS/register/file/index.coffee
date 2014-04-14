require "./items"

m=angular.module("file",['pascalprecht.translate'])
m.run = [
  "menuRegister"
  (
    register

  )->
    register.add(require("./config"))
]
m.config require("./cs_CZ")
  
m.config [
  "$stateProvider"
  ($stateProvider)->
    config=require("./config")
    $stateProvider.state("app.file.exampleSimple"
      name: "example simple"
      parent: 'app'
      template: require "./exampleSimple.html"
    )
    $stateProvider.state("app.file.twoColumns"
      name: "two col"
      parent: 'app'
      template: require "./twoColumns.html"
    )
    $stateProvider.state("app.file.dialog"
      name: "dialog"
      parent: 'app'
      template: require "./dialog.html"
    )
]

module.exports = m