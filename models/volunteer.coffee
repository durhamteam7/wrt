
mongoose = require ('mongoose')

Schema = mongoose.Schema



### Main Schema ###
volunteerCore =

	###otherModel:
		type:Schema.Types.ObjectId,
		ref:'CsiCompany',
	###

	name:
		type:String,
		default:'Default name',
		required:true,
	address:
		type: String,
		required:true,
	telHome:
		type: String
	telMob:
		type: String
	telOther:
		type: String
	email:
		type: String,

	dob:
		type: Date
	#heardFrom --- FK
	expereince:
		type: String,
	commPref:
		type: String
	#otherComm ----- FK
	photoConsent:
		type: Boolean
	lastTetnus:
		type: Date
	medCond:
		type: String
	availability:
		type: [Number]
	trained:
		type: Boolean


	car:
		reg:String,
		make: String,
		model: String,
		color: String,
	projects: [{type:Schema.Types.ObjectId,ref:'Project'}]

Volunteer = new Schema volunteerCore,validateBeforeSave:false #TEMP DISABLED VALIDATION

mongoose.model 'Volunteer',Volunteer
