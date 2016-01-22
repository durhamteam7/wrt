// app.js
angular.module('sortApp', [])

// Service
.factory('ajax', ['$http', function($http) {
  return {
    getVolunteers: function() {
      return $http.get('/api/volunteer/').success(function() {
      });
    },
    addVolunteer: function() {
      return $http.post('/api/volunteer/').success(function() {
      });
    },
    updateVolunteers: function($params) {
      $params._method = 'patch';
      console.log("update method",$params )
        return $http.post('/api/volunteer/' + $params._id, $params).success(function() {
          delete $params._method;
        });
    },
    deleteVolunteers: function(id) {
        return $http.delete('/api/volunteer/' + id).success(function() {
          console.log("deleted")
        });
    }

};}])



.controller('mainController', ['$scope', 'ajax', function($scope, serverComm) {
  
  $scope.sortType     = 'fName'; // set the default sort type
  $scope.sortReverse  = false;  // set the default sort order
  $scope.searchTerm   = '';     // set the default search/filter term

  // create the list of volunteers 
  $scope.volunteers = "";

  // Pagination variables
  $scope.currentPage = 0;
  $scope.pageSize = 10;
  $scope.numberOfPages = function() {
      return Math.ceil($scope.volunteers.length/$scope.pageSize);
  }
  $scope.rowsShown = function() {
      if (($scope.currentPage * $scope.pageSize) + $scope.pageSize < $scope.volunteers.length) {
          return Number(($scope.currentPage * $scope.pageSize) + $scope.pageSize);
      } else {
          return $scope.volunteers.length;
      }
  }
  $scope.getNumber = function(num) {
      return Array.apply(null, {length: num}).map(Number.call, Number)
  }
  $scope.isActive = function(id) {
      return id == $scope.currentPage ? 'active' : '';
  }
  // Pagination end
  
$scope.getData = function(callback) {
  serverComm.getVolunteers().success(function(data) {
    if (typeof(data) === 'object') {
      $scope.volunteers = data;
      console.log("Get data", $scope.volunteers)
    }
    if (typeof callback !== "undefined"){
      callback();
    }
  });
}

$scope.delete = function(id,index) {
  $scope.volunteers.splice(getIndexFromId(id), 1);
  serverComm.deleteVolunteers(id).success(function(data) {
    //Remove record from $scope.volunteers
  }); 
}

$scope.newVolunteer = function() {
  serverComm.addVolunteer().success(function(data) {
    //Add record to $scope.volunteers
    $scope.volunteers.push(data);
    console.log("#editModal"+data._id)
    console.log($("#editModal"+data._id))
    $("#editModal"+data._id).attr( "fish", "Beijing Brush Seller" );
    $("#editModal"+data._id).modal("toggle");

  });
}

$scope.change = function(id) {  
  //
   volunteer = $scope.volunteers[getIndexFromId(id)];
   serverComm.updateVolunteers(volunteer).success(function(data) {
  });
}


function getIndexFromId(id){
  for (i = 0; i < $scope.volunteers.length; i++) { 
      if($scope.volunteers[i]._id == id){
        return i
      }
  }
}

$scope.submitChange = function(id,index) {
  console.log("change");

  serverComm.updateVolunteers(id).success(function(data) {

  });
}

    $scope.getData();
}])

//We already have a limitTo filter built-in to angular,
//let's make a startFrom filter
.filter('startFrom', function() {
    return function(input, start) {
        start =+ start; //parse to int
        return input.slice(start);
    }
});