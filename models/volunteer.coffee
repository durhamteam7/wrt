
mongoose = require ('mongoose')

Schema = mongoose.Schema



### Main Schema ###
volunteerCore =

	Title: #dropdown
		type: String,
		required: true,
	First_Name:
		type:String,
		required: true,
	Last_Name:
		type:String,
		required: true,
	Date_of_Birth:
		type: Date,
		required: true,
	Address:
		type: String,
		required: true,
	Telephone_Home:
		type: String,
		required: true,
		validate: /^((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4})|(\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	Telephone_Mobile:
		type: String,
		required: true,
		validate: /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$/,
	Telephone_Other:
		type: String,
		validate: /^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	Email:
		type: String,
		required: true,
		validate: /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/,
	Communication_Preference: #dropdown
		type: String,
		required: true,


	Volunteering_Capacity: #dropdown
		type: String,
		required: true,
	Geographical_Area: #dropdown
		type: String,
		required: true,
	Availability: #dropdown
		type: String,
		required: true,
	Medical_Conditions:
		type: String,
		required: true,
	Last_Tetanus:
		type: Date,
		required: true,

	Has_Transport:
		type: Boolean,
		required: true,
	Car:
		Registration_Number:
			type: String,
			validate: /^([A-Z]{3}\s?(\d{3}|\d{2}|d{1})\s?[A-Z])|([A-Z]\s?(\d{3}|\d{2}|\d{1})\s?[A-Z]{3})|(([A-HK-PRSVWY][A-HJ-PR-Y])\s?([0][2-9]|[1-9][0-9])\s?[A-HJ-PR-Z]{3})$/,
		Make: String,
		Model: String,
		Colour: String,

	Experience: #dropdown
		type: String,
		required: true,

	Photographic_Consent: #dropdown
		type: Boolean,
		required: true,

	Heard_From: #dropdown
		type: String,
	Interested_In_More:
		type: Boolean,
		required: true,
	

#####emergency contact information - make as array
	Emergency_Contacts: [{
		Name:
			type: String,
			required: true,
		Relationship:
			type:String,
			required: true,
		Address:
			type: String,
			required: true,
		Telephone_Home:
			type: String,
			required: true,
			validate: /^((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4})|(\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
		Telephone_Mobile:
			type: String,
			required: true,
			validate: /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$/,
		Telephone_Other:
			type: String,
			validate: /^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
		Email:
			type: String,
			required: true,
			validate: /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/,
		}]

	Read_Health_and_Safety: #make them open it before they agree
		type: Boolean,
		required:true,


	Approved: #volunteers need to be approved, admin added volunteers are by default true
		type: Boolean,
		required: true,
		default: false,


	#stores an array of all the projects
	Projects: [{type:Schema.Types.ObjectId,ref:'Project'}]

	Trained: #dropdown
		type: Boolean,
		required: true,

Volunteer = new Schema volunteerCore,validateBeforeSave:false #TEMP DISABLED VALIDATION

mongoose.model 'Volunteer',Volunteer