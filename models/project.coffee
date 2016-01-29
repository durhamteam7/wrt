 
mongoose = require ('mongoose')

Schema = mongoose.Schema
projectCore =

	Name:
		type:String,
		default:'Default name',
		required:true,
	Description:
		type: String,
		required:true,
	Fitness_Level:
		type: String,
	Requires_Training:
		type: Boolean

project = new Schema projectCore,validateBeforeSave:false #TEMP DISABLED VALIDATION

mongoose.model 'Project',project
