
#Code to send out emails 
PDFDocument = require 'pdfkit'
express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
jsontemplate = require 'json-templater'

fs = require 'fs'
Volunteer = mongoose.model 'Volunteer'
Message = mongoose.model 'Message'

serverUrl = process.env.SERVERURL || 'http://localhost:3000'

#Routes here prefixed by /email/

router.post '/', (req,res)->
	console.log("Sending communications")
	console.log(req.body.communicationType)
	#Save message in db
	message = new Message {body:req.body.body,subject:req.body.subject,commPref:req.body.communicationType}

	if req.body.communicationType == "commPref"
		forLetter = []
		forEmail = []
		forPhone = []

		for v in req.body.select
			if v.Communication_Preference == "Email"
				forEmail.push v
			else if v.Communication_Preference == "Letter"
				forLetter.push v
			else if v.Communication_Preference == "Telephone"
				forPhone.push v
			else
				console.log("Unknown comm pref...")

		message.volunteersEmail = forEmail
		require("./sendEmails.coffee")(forEmail,req.body.body,req.body.subject)
		message.volunteersEmail = forLetter
		message.volunteersTel = forPhone

	else if req.body.communicationType == "Email"
		message.volunteersEmail = req.body.select
		require("./sendEmails.coffee")(req.body.select,req.body.body,req.body.subject)
	else if req.body.communicationType == "Letter"
		console.log("Force letter")
		message.volunteersLetter = req.body.select
	else if req.body.communicationType == "Telephone"
		message.volunteersTel = req.body.select
	else
		console.log "no comm pref"
		console.log err

	console.log(message)

	message.save (err)->
		if err
			console.log err
		else
			console.log "Saved in db"
				


router.get '/genPdf/:obj', (req,res)->
	console.log("genPDF route")
	data = JSON.parse decodeURIComponent req.params.obj
	console.log(data)
	volunteersFormatted = []
	for volunteer in data.volunteers
		v = {"body":jsontemplate.string(data.body,volunteer), "subject": jsontemplate.string(data.subject,volunteer), "address":volunteer.Address}
		volunteersFormatted.push v
	console.log volunteersFormatted
	#subject = "RE: Review of Volunteer Details"
	#body = "Dear Simon,\n\nWear Rivers Trust want to ensure that all volunteer records we keep is valid and upto date to help us achieve this we will contact every two years to review this information. Please contact Diane Maughan to inform her of any changes required and to confirm that you want to remain on our contact data base as a volunteer. \n\nIf you do not contact us within 2 months we will assume our records are incorrect or that you no longer want to volunteer for the trust. We will then suspend you application for 6 months after that period all information we hold about you will destroyed. \n\nI would like to thank you on behalf of the Trustees and Staff for choosing to donate your time this is in invaluable to us and the environment.\n\nYours Sincerely\n\n\n\nDiane Maughan\nOffice Manager"

	require("./genPDF.coffee")(req,res,volunteersFormatted)

router.get '/genEmailList/:obj', (req,res)->
	volunteers = JSON.parse decodeURIComponent req.params.obj
	vString = "<b>Email Addresses</b><br><br>"
	console.log volunteers[0]
	for v in volunteers
		vString += v.Email
		vString += "<br>"
	res.send vString

router.get '/genTelephoneList/:obj', (req,res)->
	console.log("telephoneList route")
	data = JSON.parse decodeURIComponent req.params.obj
	vString = "<h1>Telephone Numbers</h1>"
	vString += "<style>td{padding-left:30px}</style>"
	vString += data.subject+"<br><br>"
	vString += "<table><tr><td><b>Name</b></td><td><b>Home</b></td><td><b>Mobile</b></td><td><b>Other</b></td></b>"
	for v in data.volunteers
		vString += "<tr>"
		vString += "<td>"
		vString += v.First_Name+" "+v.Last_Name
		vString += "</td><td>"
		vString += v.Telephone_Home
		vString += "</td><td>"
		vString += v.Telephone_Mobile
		vString += "</td><td>"
		vString += v.Telephone_Other
		vString += "</td>"
		vString += "</tr>"
	vString +="</table>"
	res.send vString

module.exports = router
