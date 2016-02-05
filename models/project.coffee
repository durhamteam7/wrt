 
mongoose = require ('mongoose')

Schema = mongoose.Schema
projectCore =

	Name:
		type:String,
		default:'Default name',
	Description:
		type: String,
	Fitness_Level:
		type: String,
	Requires_Training:
		type: Boolean,
		default:false

project = new Schema projectCore,validateBeforeSave:false #TEMP DISABLED VALIDATION

mongoose.model 'Project',project
