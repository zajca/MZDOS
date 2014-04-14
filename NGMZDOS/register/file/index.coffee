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
      template: fs.readFileSync(__dirname + '/exampleSimple.html', 'utf8')
    )
    $stateProvider.state("app.file.twoColumns"
      name: "two col"
      parent: 'app'
      template: fs.readFileSync(__dirname + '/twoColumns.html', 'utf8')
    )
    $stateProvider.state("app.file.dialog"
      name: "dialog"
      parent: 'app'
      template: fs.readFileSync(__dirname + '/dialog.html', 'utf8')
    )
]

module.exports = m