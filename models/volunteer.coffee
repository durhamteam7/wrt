
mongoose = require ('mongoose')

Schema = mongoose.Schema



### Main Schema ###
volunteerCore =

	title: #dropdown
		type: String,
		required: true,
	fName:
		type:String,
		required: true,
	lName:
		type:String,
		required: true,
	address:
		type: String,
		required: true,
	telHome:
		type: String,
		required: true,
		validate: /^((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4})|(\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	telMob:
		type: String,
		required: true,
		validate: /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$/,
	telOther:
		type: String,
	email:
		type: String,
		required: true,
		validate: /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/,
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
		reg:
			type: String,
			validate: /^([A-Z]{3}\s?(\d{3}|\d{2}|d{1})\s?[A-Z])|([A-Z]\s?(\d{3}|\d{2}|\d{1})\s?[A-Z]{3})|(([A-HK-PRSVWY][A-HJ-PR-Y])\s?([0][2-9]|[1-9][0-9])\s?[A-HJ-PR-Z]{3})$/,
		make: String,
		model: String,
		color: String,

#####emergency contact information - make as array
	emergencyContacts: [{
		name:
			type: String,
			required: true,
		relationship:
			type:String,
			required: true,
		address:
			type: String,
			required: true,
		telHome:
			type: String,
			required: true,
			validate: /^((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4})|(\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
		telMob:
			type: String,
			required: true,
			validate: /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$/,
		telOther:
			type: String,
		email:
			type: String,
			required: true,
		}]


	readHealthAndSafety: #make them open it before they agree
		type: Boolean,
		required:true,


	approved: #volunteers need to be approved, admin added volunteers are by default true
		type: Boolean,
		required: true,
		default: false,


	#stores an array of all the projects
	projects: [{type:Schema.Types.ObjectId,ref:'Project'}]

Volunteer = new Schema volunteerCore,validateBeforeSave:false #TEMP DISABLED VALIDATION

mongoose.model 'Volunteer',Volunteer