angular.module('components', [])
  .directive('hello', function(){
    return {
      restrict: 'E',
      scope:{
        localName: '@name',
        another: '@last'
      },
      template: '<span>Hello {{localName}}, {{another}}</span>'
    }
  });