function getTag(tagString){
  return $(tagString)
}

//console.log(getTag("body"))

// app.js
angular.module('sortApp', ["checklist-model"])

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
    },
    sendEmail: function($params) {
      console.log($params)
      return $http.post('/email/', $params).success(function() {
        console.log("Emails sent")
      });
    }

  };}])

// Controller
.controller('mainController', ['$scope', 'ajax', function($scope, serverComm) {

  $scope.sortType     = 'fName'; // set the default sort type
  $scope.sortReverse  = false;   // set the default sort order
  $scope.searchTerm   = '';      // set the default search/filter term
  $scope.modelShow = false
  // create the list of volunteers 
  $scope.volunteers = {};

  $scope.select = [];
  $scope.email = {"subject":"","body":"","select":$scope.select}


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
  $scope.range = function(num) {
    return Array.apply(null, {length: num}).map(Number.call, Number)
  }
  $scope.setPage = function(num) {
    $scope.currentPage = num;
  }
  $scope.isActive = function(id) {
    return id == $scope.currentPage ? 'active' : '';
  }

  //Main data modification
  $scope.getData = function(callback) {
    $scope.modelShow = false
    serverComm.getVolunteers().success(function(data) {
      if (typeof(data) === 'object') {
        $scope.volunteers = data;
        $scope.filteredList = $scope.volunteers; // makes search work
        console.log("Get data", $scope.volunteers)
      }
      if (typeof callback !== "undefined"){
        callback();
      }
    });
  }

  $scope.delete = function(id,index) {
    serverComm.deleteVolunteers(id).success(function(data) {
        //Remove record from $scope.volunteers
        $scope.volunteers.splice(getIndexFromId(id), 1);
      }); 
  }

  $scope.newVolunteer = function() {
    $scope.modelShow = true
    //console.log(angular.element("#yes"))
    serverComm.addVolunteer().success(function(data) {
        //Add record to $scope.volunteers
        $scope.volunteers.push(data);
        //getTag("#editModal" + data._id).modal();
        //console.log(getTag("#editModal" + data._id));

      });
  }

  $scope.change = function(id) {  
    //
    volunteer = $scope.volunteers[getIndexFromId(id)];
    serverComm.updateVolunteers(volunteer).success(function(data) {
        //Add record to $scope.volunteers
      
      });
  }


  function getIndexFromId(id) {
    for (i = 0; i < $scope.volunteers.length; i++) { 
      if ($scope.volunteers[i]._id == id) {
        return i
      }
    }
  }
  
  $scope.getIdFromIndex = function(index) {
    return $scope.volunteers[index].id
  }

  $scope.submitChange = function(id,index) {
    console.log("change");

    serverComm.updateVolunteers(id).success(function(data) {

    });
  }

  $scope.sendEmail = function(id,index) {
    console.log("change");

    serverComm.sendEmail($scope.email).success(function(data) {

    });
  }

  // Logic for check-all checkbox
  $scope.checkAll = function () {
      console.log("tick!");
      console.log($scope.selectedAll);
    if ($scope.selectedAll) {
      $scope.selectedAll = true;
    } else {
      $scope.selectedAll = false;
    }
    angular.forEach($scope.volunteers, function (v) {
      v.isSelected = $scope.selectedAll;
    });
  };
  
  $scope.selected = function() {
      a = [];
      angular.forEach($scope.filteredList, function (v) {
      if (v.isSelected) {
          a.push(v);
      }
    });
    return a;
  }
  
  //new
  $scope.$watch('searchTerm', function () {
    $scope.filteredList = $scope.$eval('volunteers | filter:searchTerm');
  });
  // end new

  $scope.getData();
}])
// new
.directive('selectAllCheckbox', function () {
  return {
    replace: true,
    restrict: 'E',
    scope: {
      checkboxes: '=',
      allselected: '=allSelected',
      allclear: '=allClear',
      multiple: '=multiple',
      ids: '=ids'
    },
    template: '<input type="checkbox" class="input-checkbox" ng-model="master" ng-change="masterChange()">',
    controller: function ($scope, $element) {
      $scope.masterChange = function () {
        if ($scope.master) {
          angular.forEach($scope.checkboxes, function (cb, index) {
            cb.isSelected = true;
          });
        } else {
         angular.forEach($scope.checkboxes, function (cb, index) {
            cb.isSelected = false;
          });
        }
      };
      $scope.$watchCollection('checkboxes', function (newVal,oldVal) {
        if(newVal !== oldVal){
          var allSet = true,allClear = true, countSelected = 0;
          $scope.ids = [];
          angular.forEach($scope.checkboxes, function (cb, index) {
            if(cb.isSelected){
              countSelected ++;
              $scope.ids.push(cb.id);
            }
            if (cb.isSelected) {
              allClear = false;
            } else {
              allSet = false;
            }
          });
          if(countSelected > 1){
            $scope.multiple = true
          }else{
            $scope.multiple = false
          }
          if ($scope.allselected !== undefined) {
            $scope.allselected = allSet;
          }
          if ($scope.allclear !== undefined) {
            $scope.allclear = allClear;
          }

          $element.prop('indeterminate', false);
          if (allSet) {
            $scope.master = true;
          } else if (allClear) {
            $scope.master = false;
          } else {
            $scope.master = false;
            $element.prop('indeterminate', true);
          }
        }
      }, true);
    }
  };
})
//end new

//We already have a limitTo filter built-in to angular,
//let's make a startFrom filter
.filter('startFrom', function() {
  return function(input, start) {
    start =+ start; //parse to int
    return input.slice(start);
    }
})

//Directive for DOM manipulation
.directive('displayModal', function() {
    
    return {
        restrict: 'A', // restricts the use of the directive (use it as an attribute)
        link: function(scope, elm, attrs) { // fires when the element is created and is linked to the scope of the parent controller
            console.log(scope.modelShow)
            if (scope.modelShow){
              console.log("MODEL TIME")
              elm.modal();
            }
        }
    };
    
});