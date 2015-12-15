
mongoose = require ('mongoose')

Schema = mongoose.Schema



### Main Schema ###
volunteerCore =

	title: #dropdown
		type: String,
		required: true,
	name:
		type:String,
		required: true,
	address:
		type: String,
		required: true,
	telHome:
		type: String,
		required: true,
	telMob:
		type: String,
		required: true,
	telOther:
		type: String,
	email:
		type: String,
		required: true,
	dob:
		type: Date,
		required: true,


	volunteeringType: #dropdown
		type: String,
		required: true,
	preferredArea: #dropdown
		type: String,
		required: true,
	availability: #dropdown
		type: [Number],
		required: true,
	trained: #dropdown
		type: Boolean,
		required: true,
	physicalFitnessLevel:
		type: String,
		required: true, 

	experience: #dropdown
		type: String,
		required: true,
	commPref: #dropdown
		type: String,
		required: true,
	photoConsent: #dropdown
		type: Boolean,
		required: true,
	lastTetnus: 
		type: Date,
		required: true,
	medCond:
		type: String,
		required: true,
	heardFrom: #dropdown
		type: String,
	interestedInMore:
		type: Boolean,
		required: true,
		

	hasTransport:
		type: Boolean,
		required: true,
	car:
		reg: String,
		make: String,
		model: String,
		color: String,

#####emergency contact information - make as array

	readHealthAndSafety: #make them open it before they agree
		type: Boolean,
		required:true,


	#stores an array of all the projects
	projects: [{type:Schema.Types.ObjectId,ref:'Project'}]

Volunteer = new Schema volunteerCore,validateBeforeSave:false #TEMP DISABLED VALIDATION

mongoose.model 'Volunteer',Volunteer
