
try
	#Server-side
	mongoose = require ('mongoose')
catch
	#Clientside (requires that scripts are alread loaded in browser)
	mongoose = window.mongoose


Schema = mongoose.Schema



### Main Schema ###
volunteerCore =

	Title: #dropdown
		type: String,
	First_Name:
		type:String,
	Last_Name:
		type:String,
	Date_of_Birth:
		type: Date,
	Address:
		type: String,
	Telephone_Home:
		type: String,
		validate: /^((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4})|(\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	Telephone_Mobile:
		type: String,
		validate: /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$/,
	Telephone_Other:
		type: String,
		validate: /^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	Email:
		type: String,
		validate: /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/,
	Communication_Preference: #dropdown
		type: String,
		default: "Email"


	Volunteering_Capacity: #dropdown
		type: String,
	Geographical_Area: #dropdown
		type: String,
	Availability: #dropdown
		type: String,
	Experience: #dropdown
		type: String,
	Medical_Conditions:
		type: String,
	Last_Tetanus:
		type: Date,

	Has_Transport:
		type: Boolean,
		
	Car_Registration_Number:
		type: String,
		validate: /^([A-Z]{3}\s?(\d{3}|\d{2}|d{1})\s?[A-Z])|([A-Z]\s?(\d{3}|\d{2}|\d{1})\s?[A-Z]{3})|(([A-HK-PRSVWY][A-HJ-PR-Y])\s?([0][2-9]|[1-9][0-9])\s?[A-HJ-PR-Z]{3})$/,
	Car_Make:
		type: String,
	Car_Model:
		type: String,
	Car_Colour:
		type: String,
	
	Emergency_Name_1:
		type: String,
	Emergency_Relationship_1:
		type:String,
	Emergency_Address_1:
		type: String,
	Emergency_Telephone_Home_1:
		type: String,
		validate: /^((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4})|(\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	Emergency_Telephone_Mobile_1:
		type: String,
		validate: /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$/,
	Emergency_Telephone_Other_1:
		type: String,
		validate: /^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	Emergency_Email_1:
		type: String,
		validate: /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/,
	
	Emergency_Name_2:
		type: String,
	Emergency_Relationship_2:
		type:String,
	Emergency_Address_2:
		type: String,
	Emergency_Telephone_Home_2:
		type: String,
		validate: /^((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4})|(\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	Emergency_Telephone_Mobile_2:
		type: String,
		validate: /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$/,
	Emergency_Telephone_Other_2:
		type: String,
		validate: /^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/,
	Emergency_Email_2:
		type: String,
		validate: /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/,

	Heard_From: #dropdown
		type: String,
		
	Interested_In_More:
		type: Boolean,

	Photographic_Consent: #dropdown
		type: Boolean,

	Read_Health_and_Safety: #Do we even need to store this??????
		type: Boolean,

	Approved: #volunteers need to be approved, admin added volunteers are by default true
		type: Boolean,
		default: false,

	#stores an array of all the volunteering opportunities
	Volunteering_Opportunities: [{ type: Schema.Types.ObjectId, ref: 'Volunteering_Opportunity' }]

	Trained: #dropdown
		type: Boolean,

Volunteer = new Schema volunteerCore, { validateBeforeSave: false, timestamps: true } #TEMP DISABLED VALIDATION


try #Server-side
	mongoose.model 'Volunteer',Volunteer
#module.exports = CsiSite

try #Expose variable to client-side
	window.volunteerCore = volunteerCore
	window.Volunteer = Volunteer
