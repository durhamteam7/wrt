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
    getApprovedVolunteers: function() {
      return $http.get('/api/volunteer/approved').success(function() {
      });
    },
    getUnapprovedVolunteers: function() {
      return $http.get('/api/volunteer/unapproved').success(function() {
      });
    },
    approveVolunteers: function(id) {
      return $http.patch('/api/volunteer/approve/' + id).success(function() {
        console.log("approved")
      });
    },
    unapproveVolunteers: function(id) {
      return $http.patch('/api/volunteer/unapprove/' + id).success(function() {
        console.log("unapproved")
      });
    },
    addVolunteer: function() {
      return $http.post('/api/volunteer/approve/').success(function() {
      });
    },
    updateVolunteers: function($params) {
      $params._method = 'patch';
      console.log("update method", $params)
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
  };
}])



// Controller
.controller('mainController', ['$scope', 'ajax', function($scope, serverComm) {

  $scope.sortType     = 'First_Name'; // set the default sort type
  $scope.sortReverse  = false;   // set the default sort order
  $scope.searchTerm   = '';      // set the default search/filter term
  $scope.modelShow    = false;
  // create the list of volunteers 
  $scope.volunteers = {};
  $scope.mode = "normal";

  $scope.select = [];
  $scope.email = { "subject": "", "body": "", "select": $scope.select }
  $scope.emailPreview = { "subject": "", "body": "" }

  $scope.allTableHeadings = ["Title", "First_Name", "Last_Name", "Email", "Telephone_Home", "Telephone_Mobile", "Telephone_Other", "Address", "Volunteering_Type", "Has_Transport", "Communication_Preference"];
  $scope.tableHeadings = ["First_Name", "Last_Name", "Email", "Telephone_Home"];

  // Pagination variables
  $scope.currentPage = 0;
  $scope.pageSizeOptions = [10, 25, 50, 100];
  $scope.pageSize = $scope.pageSizeOptions[1];
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
  $scope.isSelected = function(v) {
    console.log(v.isSelected)
  }
                          
  $scope.isIn = function(value, array) {
      return jQuery.inArray(value, array)
  }
  
  $scope.sortBy = function(attribute) {
	  $scope.sortType = attribute
  }
  $scope.reverseSort = function() {
	  $scope.sortReverse = !$scope.sortReverse
  }
  $scope.isSortType = function(attribute) {
	  if ($scope.sortType == attribute) {
		  return true
	  } else {
		  return false
	  }
  }

  //Main data modification - Gets all approved volunteers
  $scope.getApproved = function(callback) {
    $scope.modelShow = false
    serverComm.getApprovedVolunteers().success(function(data) {
      if (typeof(data) === 'object') {
        $scope.volunteers = data;
        $scope.filteredList = $scope.volunteers; // makes search work
        console.log("Get data", $scope.volunteers)
        
        $scope.setNumberOfUnapprovedVolunteers();
        
        $scope.mode = "normal";
      }
      if (typeof callback !== "undefined") {
        callback();
      }
       $("#loader").fadeOut("slow");
    });
  }
  
  // Gets all unapproved volunteers
  $scope.getUnapproved = function(callback) {
    $scope.modelShow = false
    serverComm.getUnapprovedVolunteers().success(function(data) {
      if (typeof(data) === 'object') {
        $scope.volunteers = data;
        $scope.filteredList = $scope.volunteers; // makes search work
        console.log("Get data", $scope.volunteers)
        
        $scope.mode = "approving";
      }
      if (typeof callback !== "undefined") {
        callback();
      }
    });
  }

  $scope.setNumberOfUnapprovedVolunteers = function() {
    serverComm.getUnapprovedVolunteers().success(function(data) {
        $scope.numberOfUnapprovedVolunteers = data.length;
    });  
  }

  $scope.getNumberOfUnapprovedVolunteers = function() {
      if ($scope.numberOfUnapprovedVolunteers == 0) {
          return "No";
      } else {
          return $scope.numberOfUnapprovedVolunteers;
      }
  }

  $scope.delete = function(id, index) {
    serverComm.deleteVolunteers(id).success(function(data) {
        //Remove record from $scope.volunteers
        $scope.volunteers.splice(getIndexFromId(id), 1);
      }); 
  }

  $scope.approve = function(id, index) {
    serverComm.approveVolunteers(id).success(function(data) {
        //Remove record from $scope.volunteers
        $scope.volunteers.splice(getIndexFromId(id), 1);
      }); 
  }

  $scope.unapprove = function(id, index) {
    serverComm.unapproveVolunteers(id).success(function(data) {
        //Remove record from $scope.volunteers
        //$scope.volunteers.splice(getIndexFromId(id), 1);
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
  
  $scope.readable = function(string) {
      return string.replace("_", " ")
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

  $scope.submitChange = function(volunteer) {
    serverComm.updateVolunteers(volunteer).success();
  }

  $scope.sendEmail = function(id,index) {
    serverComm.sendEmail($scope.email).success(function(data) {
    });
  }

  $scope.emailChange = function() {
    $scope.emailPreview = {"subject":Mustache.render($scope.email.subject, $scope.select[0]),"body":Mustache.render($scope.email.body, $scope.select[0])}
  }
  
  $scope.logout = function() {
    window.location = '/logout';
  }

  // Logic for check-all checkbox
  $scope.checkAll = function () {
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
  
  $scope.getApproved();
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

.directive("contenteditable", function() {
  return {
    restrict: "A",
    require: "ngModel",
    link: function(scope, element, attrs, ngModel) {

      function read() {
        ngModel.$setViewValue(element.html());
      }

      ngModel.$render = function() {
        element.html(ngModel.$viewValue || "");
      };

      element.bind("blur keyup change", function() {
        scope.$apply(read);
      });
    }
  };
})


//Directive for DOM manipulation
.directive('displayModal', function() {
    
    return {
        restrict: 'A', // restricts the use of the directive (use it as an attribute)
        link: function(scope, elm, attrs) { // fires when the element is created and is linked to the scope of the parent controller
            if (scope.modelShow){
              elm.modal();
            }
        }
    };
    
});