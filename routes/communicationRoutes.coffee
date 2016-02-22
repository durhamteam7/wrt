
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
	console.log("Comm route")
	require("./sendCommunication.coffee")(req.body.communicationType,req.body.body,req.body.subject,req.body.select)
	res.send 200
				


router.get '/genPdf/:obj', (req,res)->
	console.log("genPDF route")
	data = JSON.parse decodeURIComponent req.params.obj
	console.log(data)
	volunteersFormatted = []
	for volunteer in data.volunteers
		v = {"body":jsontemplate.string(data.body,volunteer), "subject": jsontemplate.string(data.subject,volunteer), "address":volunteer.Address}
		volunteersFormatted.push v
	console.log volunteersFormatted
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
