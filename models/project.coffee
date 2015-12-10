 
mongoose = require ('mongoose')

Schema = mongoose.Schema
projectCore =

	name:
		type:String,
		default:'Default name',
		required:true,
	description:
		type: String,
		required:true,
	fitnessLevel:
		type: String,
	requiresTraining:
		type: Boolean

project = new Schema projectCore,validateBeforeSave:false #TEMP DISABLED VALIDATION

mongoose.model 'Project',project
