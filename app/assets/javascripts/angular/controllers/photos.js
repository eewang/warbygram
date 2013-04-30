var PhotoApp = angular.module('PhotoApp', ['ngResource']);

PhotoApp.factory('Data', function(){
  return {message: "I'm data from the PhotoApp"}
})

PhotoApp.factory('Photo', function($resource){
  return $resource('photos.json', {}, {
    query: {method: 'GET', params: {photoId: 'photos'}, isArray: true}
  });
});

function PhotoCtrl($scope, Photo){
  $scope.photos = Photo.query();

  $scope.getTotalPhotos = function(){
    // console.log($scope.photos.length);
    return $scope.photos.length;
  }

  $scope.changeName = function(photo, newName){
    photo.name = newName
  }

  $scope.remove = function(photo){
    var index = $scope.photos.indexOf(photo)
    $scope.photos.splice(index, 1);
  }

  $scope.detailPhoto = function(){
    return "hello this is a test";
  }

  // $scope.changeStyle = function(photo){
  //   $scope.selected = photo;
  // }

  // $scope.returnSelectPhoto = function(photo){

  // }

  // $scope.selectPhoto = function(photo) {
  //   return $scope.selected === photo;
  // }

}

function PhotoDetailCtrl($scope, Photo){
  
}
