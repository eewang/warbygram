

var PhotoApp = angular.module('PhotoApp', ['ngResource', 'components']);

PhotoApp.factory('Data', function(){
  return {message: "I'm data from the PhotoApp"}
})

PhotoApp.factory('Photo', function($resource){
  return $resource('photo_feed.json', {}, {
    query: {method: 'GET', params: {photoId: 'photos'}, isArray: true}
  });
});

PhotoApp.factory('Comment', function($resource){
  return $resource('comments.json', {}, {
    query: {method: 'GET', params: {commentId: 'comments'}, isArray: true}
  });
});


// PhotoApp.factory('Frames', function($resource){
//   return $resource('comment_data.json', {}, {
//     query: {method: 'GET', params: {commentId: 'comments'}, isArray: true}
//   });
// });

function FramesCtrl($scope, $http){
  $scope.test = "hello";

  // $scope.frames = $http.get('/comment_data');
}

function CommentCtrl($scope, Comment){
  $scope.comments = Comment.query();

  $scope.getComments = function(){
    return $scope.comments[number];
  }

}

function PhotoCtrl($scope, Photo, $http){
  $scope.photos = Photo.query();

  $scope.test = function(){
    return "this is a test";
  }

  $scope.getComments = function(){
    comment = $http.get('comments/100.json')
    console.log(comment.comment);
  }

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

}

function PhotoDetailCtrl($scope, Photo){
  
}
