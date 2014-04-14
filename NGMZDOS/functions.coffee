module.exports = m
m = angular.module("mzdos.functions",[])
m.factory("functions",["",()->
  removeFromArrayByValue: (array,value) ->
    index = array.indexOf(item)
    array.splice(index, 1)
  ]
)