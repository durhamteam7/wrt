 
mongoose = require ('mongoose')

Schema = mongoose.Schema
volunteeringOpportunityCore =
	Name:
		type: String,
		default:'Default name',
	Description:
		type: String,
	Fitness_Level:
		type: String,
	Requires_Training:
		type: Boolean,
		default: false

volunteeringOpportunity = new Schema volunteeringOpportunityCore, { collection : 'volunteeringOpportunities' }, validateBeforeSave: false #TEMP DISABLED VALIDATION

mongoose.model 'Volunteering_Opportunity', volunteeringOpportunity
