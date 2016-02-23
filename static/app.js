function getTag(tagString){
  return $(tagString)
}

function coffeeLoaded() {
  //Tells angular that coffee is loaded so it can start
  initModel();
}

//console.log(getTag("body"))

// app.js
angular.module('sortApp', ["checklist-model","ngSanitize","confirmClick"])

// Service
.factory('ajax', ['$http', function($http) {
  return {
    getVolunteers: function() {
      return $http.get('/api/volunteer/').success(function() {
      });
    },
    approveVolunteers: function(id) {
      return $http.patch('/api/volunteer/approve/' + id).success(function() {
        console.log("approved")
      });
    },
    addVolunteer: function() {
      return $http.post('/api/volunteer/approve/').success(function() {
      });
    },
    updateVolunteers: function($params) {
      $params._method = 'patch';
      return $http.post('/api/volunteer/' + $params._id, $params).success(function() {
        delete $params._method;
      });
    },
    deleteVolunteers: function(id) {
      return $http.delete('/api/volunteer/' + id).success(function() {
        console.log("deleted")
      });
    },
    getVolunteeringOpportunities: function() {
      return $http.get('/api/volunteeringOpportunity').success(function() {
      });
    },
    updateVolunteeringOpportunity: function($params) {
      $params._method = 'patch';
      console.log("update method", $params);
      return $http.patch('/api/volunteeringOpportunity/' + $params._id, $params).success(function() {
        delete $params._method;
      });
    },
    addVolunteeringOpportunity: function() {
      return $http.post('/api/volunteeringOpportunity/').success(function() {
      });
    },
    deleteVolunteeringOpportunity: function(id) {
      return $http.delete('/api/volunteeringOpportunity/' + id).success(function() {
        console.log("deleted")
      });
    },
    getUsers: function() {
      return $http.get('/api/user').success(function() {
      });
    },
    getUser: function($id) {
      return $http.get('api/user/' + $id).success(function() {
      });
    },
    updateUser: function($params) {
      $params._method = 'patch';
      //console.log("update method", $params)
      return $http.post('/api/user/' + $params._id, $params).success(function() {
        delete $params._method;
      });
    },
    getMessages: function() {
      return $http.get('/api/message/').success(function() {
      });
    },
    getUnseen: function() {
      return $http.get('/api/message/unsent').success(function() {
      });
    },
    setRead: function(id,type) {
      console.log("setReAD")
      return $http.post('/api/message/send'+type+'/'+id,{_method:'patch'}).success(function() {
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
.controller('mainController', ['$scope', '$window', '$filter', 'ajax', function($scope, $window, $filter, serverComm) {
  
  $scope.user = {};

  $scope.validationError = null;

  $scope.sortType     = 'First_Name'; // set the default sort type
  $scope.sortReverse  = false;   // set the default sort order
  $scope.searchTerm   = '';      // set the default search/filter term
  $scope.modelShow    = false;
  // create the list of volunteers 
  $scope.volunteers = {};
  $scope.approvedVolunteers = {};
  $scope.unapprovedVolunteers = {};
  $scope.mode = "normal";

  
  $scope.unseenMessages = 0; // set to actual number of unseen messages
  $scope.sendStatus = 0;

  $scope.select = [];
  $scope.email = { "subject": "", "body": "", "select": $scope.select }
  $scope.emailPreview = { "subject": "", "body": "" }
  $scope.email.communicationType = "commPref"
  $scope.messageLog = {}

  $scope.allTableHeadings = ["Title", "First_Name", "Last_Name", "Email", "Date_of_Birth", "Telephone_Home", "Telephone_Mobile", "Telephone_Other", "Address", "Volunteering_Type", "Has_Transport", "Communication_Preference"];
  $scope.tableHeadings = ["First_Name", "Last_Name", "Email", "Telephone_Home"]; // Default headings if user preference not set

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
  
  $scope.readable = function(string) {
      return string.replace(/_/g, " ")
  }

  //****************Main data modification*****************************
  //Volunteers
  $scope.getVolunteers = function(callback) {
    $scope.modelShow = false;
    serverComm.getVolunteers().success(function(data) {
      if (typeof(data) === 'object') {
        $scope.volunteers = data;
		$scope.approvedVolunteers = $scope.$eval('volunteers | filter: { Approved: true} ');
		$scope.unapprovedVolunteers = $scope.$eval('volunteers | filter: { Approved: false} ');
		
		$scope.volunteers = $scope.approvedVolunteers;
        $scope.filteredList = $scope.volunteers; // makes search work
        console.log("All volunteers", data);
        console.log("Approved volunteers", $scope.volunteers);
        console.log("Unapproved volunteers", $scope.unapprovedVolunteers);
        
        $scope.numberOfUnapprovedVolunteers = $scope.unapprovedVolunteers.length;
        
        $scope.mode = "normal";
      }
      if (typeof callback !== "undefined") {
        callback();
      }
       $("#loader").fadeOut("slow");
    });
  }
  
  $scope.getUnapproved = function(callback) {
    // Gets all unapproved volunteers
  	$scope.modelShow = false
  	
  	$scope.volunteers = $scope.unapprovedVolunteers;
  	$scope.filteredList = $scope.volunteers; // makes search work
  	console.log("Get data", $scope.volunteers)
  	
  	$scope.mode = "approving";
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
      $scope.volunteers.splice(getIndexFromId($scope.volunteers, id), 1);
    });
  }

  $scope.approve = function(id, index) {
    serverComm.approveVolunteers(id).success(function(data) {
      //Remove record from $scope.volunteers
      $scope.volunteers.splice(getIndexFromId($scope.volunteers, id), 1);
    }); 
  }

  $scope.newVolunteer = function() {
    $scope.modelShow = true
    serverComm.addVolunteer().success(function(data) {
	  //Add record to $scope.volunteers
	  $scope.volunteers.push(data);
	});
  }

  function getIndexFromId(list, id) {
    for (i = 0; i < list.length; i++) { 
      if (list[i]._id == id) {
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
  
  //Volunteering Opportunity
  $scope.getVolunteeringOpportunities = function() {
	  serverComm.getVolunteeringOpportunities().success(function(data) {
		  $scope.volunteeringOpportunities = data;
		  $scope.selectedOpportunity = {};
	  });
  }
  
  $scope.updateVolunteeringOpportunity = function(opportunity) {
    serverComm.updateVolunteeringOpportunity(opportunity).success();
  }

	$scope.newOpportunity = function() {
		serverComm.addVolunteeringOpportunity().success(function(data) {
			$scope.volunteeringOpportunities.push(data);
			$scope.selectedOpportunity = data;
		});
	}

	$scope.deleteOpportunity = function(id, index) {
		serverComm.deleteVolunteeringOpportunity(id).success(function(data) {
      $scope.volunteeringOpportunities.splice(getIndexFromId($scope.volunteeringOpportunities, id), 1);
		});
	}

	// 
	$scope.opportunityName = function(ids) {
		if ($scope.volunteeringOpportunities) {
			var names = [];
			angular.forEach(ids, function(id) {
				var index = "";
				for (var i = 0; i < $scope.volunteeringOpportunities.length; i++) {
					if ($scope.volunteeringOpportunities[i]._id == id) {
						index = i
					}
				}
				if (index !== "") {
					o = $scope.volunteeringOpportunities[index];
					names.push(o.Name);
				}
			});
			return names.join(", ");
		}
	}
	
	$scope.dateFormat = function(value) {
		return $filter('date')(value, 'yyyy-MM-dd');
	}
 
	// Inline editing for Volunteering Opportunities
	// Gets the template to ng-include for a table row / item
	$scope.getTemplate = function (o) {
		if (o._id === $scope.selectedOpportunity._id) return 'edit';
		else return 'display';
	};

	$scope.editOpportunity = function (o) {
		$scope.selectedOpportunity = angular.copy(o);
	};

	$scope.saveOpportunity = function (idx) {
		console.log("Saving Opportunity");
		$scope.volunteeringOpportunities[idx] = angular.copy($scope.selectedOpportunity);
		$scope.updateVolunteeringOpportunity($scope.selectedOpportunity);
		$scope.resetSelectedOpportunity();
	};

	$scope.resetSelectedOpportunity = function () {
		$scope.selectedOpportunity = {};
	};
  
  //USER
  $scope.getUser = function() {
	  serverComm.getUser(userId).success(function(data) {
		  $scope.user = data;
      $scope.username = $scope.user.username;

		  console.log("User", $scope.user);
		  if ($scope.user.tableHeadings != "") {
		  	  $scope.tableHeadings = JSON.parse($scope.user.tableHeadings);
		  }
	  });
  }

  $scope.updatePassword = function() {

    if ($scope.newPassword !== "" && $scope.newPassword === $scope.passwordConfirm){
      $scope.user.password = $scope.newPassword;
      $scope.user.oldPassword = $scope.oldPassword
    }
    if ($scope.username !== ""){
      $scope.user.username = $scope.username;
    }
    serverComm.updateUser($scope.user).success(function(data){
      $scope.passwordSuccess = 1
      $scope.newPassword = "";
      $scope.passwordConfirm = "";
    }).error(function(data){
      $scope.passwordSuccess = -1;
    });

    $scope.oldPassword = "";

  }
  
  $scope.updateUser = function() {
    $scope.user.tableHeadings = JSON.stringify($scope.tableHeadings)
	  serverComm.updateUser($scope.user).success();
  }
	
	$scope.updateUserCredentials = function() {
		//console.log($scope.user);
		// $scope.user.password = $scope.user.passwordConfirm is the new password
		// use this to generate the db hash
		//serverComm.updateUser(user).success();
		$scope.user.password = "";
		$scope.user.passwordConfirm = "";
	}

  //Email
  $scope.sendEmail = function(id,index) {
    $scope.sendStatus = 1
    body = $scope.email.body.replace(/<\/p>/gi, "\n").replace(/<br\/?>/gi, "\n").replace(/<\/?[^>]+(>|$)/g, "");
    var re = new RegExp(String.fromCharCode(160), "g");
    body =  body.replace(/&nbsp;/g, ' ');
    email = $scope.email
    email.body = body
    pdfLink = serverComm.sendEmail($scope.email).success(function(data) {
      console.log("EMAIL SENT");
      $scope.getMessages();
      $scope.sendStatus = 2;
    });
  }

  $scope.emailChange = function() {
    console.log($scope.email.body)
    body = $scope.email.body.replace(/<\/p>/gi, "\n").replace(/<br\/?>/gi, "\n").replace(/<\/?[^>]+(>|$)/g, "");
    var re = new RegExp(String.fromCharCode(160), "g");
    body =  body.replace(/&nbsp;/g, ' ');
    console.log(body)
    $scope.emailPreview = {"subject": Mustache.render($scope.email.subject, $scope.select[0]),"body":Mustache.render(body, $scope.select[0])}
    console.log($scope.emailPreview.body)
  }
  
  $scope.getMessages = function() {
    console.log("Getting log...")
     serverComm.getMessages().success(function(data) {
        $scope.messageLog = data
        console.log(data)
        $scope.getUnseen();
     });
  }

  $scope.getUnseen = function() {
     serverComm.getUnseen().success(function(data) {
        $scope.unseenMessages = data
        console.log(data)
          title = $window.document.title.split(" (")[0];
        if (data > 0){
          $window.document.title = title + " ("+data+")";
        }
        else{
          $window.document.title = title
        }
     });
  }

  $scope.read = function(id,type){
    console.log(id,type);
    serverComm.setRead(id,type).success(function(data){
      //get updated total of unread messages
      $scope.unseenMessages--;
      $scope.getMessages();
    })
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


  //Validation
  $scope.validate = function(volunteer) {
    console.time("validate")
    if (typeof $scope.VolunteerModel !== "undefined") {
      //$scope.validationError = null;
      $scope.VolunteerModel = recurseApply($scope.VolunteerModel,volunteer)
      $scope.VolunteerModel.validate(function(err) {
        isValid = true
        if ($scope.VolunteerModel.errors) {
          $scope.validationError = {};
          $scope.validationError.errors = $scope.VolunteerModel.errors;

          //Convert error JSON into array
          var arr = Object.keys($scope.validationError.errors).map(function(k) {
            return $scope.validationError.errors[k]
          });

          if (arr.length !== 0) {
            isValid = false
          }
        }

        if (isValid) {
          $scope.validationError = null;
        } else {
          //console.log("Validation Failed")
          //console.log($scope.validationError)
          //$scope.$apply();
          return $scope.$apply();
        }
        console.timeEnd("validate")
      });
    }
  };

  initModel = function() {
    console.log("init model")
    console.log(Volunteer)
    $scope.VolunteerModel = new mongoose.Document({}, new mongoose.Schema(volunteerCore,{validateBeforeSave:false}));
    $scope.allTableHeadings = Object.keys(volunteerCore);
    console.log("Model init", $scope.VolunteerModel);
    $scope.getVolunteers();
    $scope.getMessages();
    $scope.getUnseen();
  };

  
  //search filter
  $scope.$watch('searchTerm', function () {
    $scope.filteredList = $scope.$eval('volunteers | filter:searchTerm');
  });
  
  $scope.getUser();
  $scope.getVolunteeringOpportunities();
  $scope.getVolunteers();
  
}])


// check all checkbox directive
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


//We already have a limitTo filter built-in to angular,
//let's make a startFrom filter
.filter('startFrom', function() {
  return function(input, start) {
    start =+ start; //parse to int
	if (start <= input.length)
    	return input.slice(start);
    }
})

//Directive doing ?
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

//Directive for DOM manipulation - showing modals
.directive('displayModal', function() {
    
    return {
        restrict: 'A', // restricts the use of the directive (use it as an attribute)
        link: function(scope, elm, attrs) { // fires when the element is created and is linked to the scope of the parent controller
            if (scope.modelShow){
              elm.modal();
            }
        }
    };
    
})

//Directive for processing Date format
.directive("input", function() {
    return {
        require: 'ngModel',
        link: function(scope, elem, attr, modelCtrl) {
            if (attr['type'] === 'date'){
                modelCtrl.$formatters.push(function(modelValue) {
                    if (modelValue) {
												date = new Date(modelValue);
                        return date;
                    }
                    else {
                        return null;
                    }
                });
            }

        }
    };
})


//Multiple Select Directive
.directive('dropdownMultiselect', function() {
   return {
       restrict: 'E',
       scope:{           
            model: '=',
            options: '=',
            pre_selected: '=preSelected'
       },
       template: "<div class='btn-group btn-block' data-ng-class='{open: open}'>"+
                	"<button class='form-control btn btn-text dropdown-toggle' data-ng-click='open=!open;openDropdown()'>Choose Volunteering Opportunities <span class='caret'></span></button>"+
					"<ul class='dropdown-menu control-group list-inline' aria-labelledby='dropdownMenu'>" + 
						"<li class='col-xs-12'><a data-ng-click='selectAll()'><i class='icon-ok-sign'></i>  Check All</a></li>" +
						"<li class='col-xs-12'><a data-ng-click='deselectAll();'><i class='icon-remove-sign'></i>  Uncheck All</a></li>" +                    
						"<li class='divider col-xs-12'></li>" +
						"<li class='col-xs-12' data-ng-repeat='option in options'> <a data-ng-click='setSelectedItem()'>{{option.Name}}<span data-ng-class='isChecked(option._id)'></span></a></li>" +                                        
					"</ul>" +
                 "</div>" ,
       controller: function($scope) {
           
           $scope.openDropdown = function() {        
				$scope.selected_items = [];
				for (var i = 0; i < $scope.pre_selected.length; i++) {
					$scope.selected_items.push($scope.pre_selected[i]._id);
				}
            };
           
            $scope.selectAll = function () {
                $scope.model = _.pluck($scope.options, '_id');
                console.log($scope.model);
            };            
            $scope.deselectAll = function() {
                $scope.model = [];
                console.log($scope.model);
            };
            $scope.setSelectedItem = function() {
                var id = this.option._id;
                if (_.contains($scope.model, id)) {
                    $scope.model = _.without($scope.model, id);
                } else {
                    $scope.model.push(id);
                }
                console.log($scope.model);
                return false;
            };
            $scope.isChecked = function (id) {
                if (_.contains($scope.model, id)) {
                    return 'glyphicon glyphicon-ok pull-right';
                }
                return '';
            };
       }
   } 
})

function recurseApply(target, data) {
  var key, subDiff;
  for (key in data) {
    if (typeof target === "undefined") {
      target = {};
    }
    if ((typeof data[key]) === 'object' && data[key] !== null) {
      if (Object.keys(data[key]).length > 0) {
        subDiff = recurseApply(target[key], data[key]);
        target[key] = subDiff;
      }
    }
    else {
      target[key] = data[key];
    }
  }
  return target;
}