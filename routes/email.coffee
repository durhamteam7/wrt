
#Code to send out emails 
PDFDocument = require 'pdfkit'
express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
nodemailer = require 'nodemailer'
Host = mongoose.model 'Host'
fs = require 'fs'
Volunteer = mongoose.model 'Volunteer'
jsontemplate = require 'json-templater'

serverUrl = process.env.SERVERURL || 'http://localhost:3000'

#Routes here prefixed by /email/

router.post '/', (req,res)->
	console.log("Sending communications")
	console.log(req.body.communicationType)
	if req.body.communicationType == "commPref"
		forLetter = []
		forEmail = []

		for v in req.body.select
			if v.Communication_Preference == "Email"
				forEmail.push v
			else if v.Communication_Preference == "Letter"
				forLetter.push v
			else
				console.log("Unknown comm pref...")
		console.log("Email",forEmail)
		console.log("letter",forLetter)
		sendEmails(forEmail,req.body.body,req.body.subject)
		res.send "email/genPdf/"+encodeURIComponent(JSON.stringify({"volunteers":forLetter,"body":req.body.body,"subject":req.body.subject}))

	else if req.body.communicationType == "Email"
		sendEmails(req.body.select,req.body.body,req.body.subject)
	else if req.body.communicationType == "Letter"
		res.send "/email/genPdf/"+encodeURIComponent(JSON.stringify({"volunteers":req.body.select,"body":req.body.body,"subject":req.body.subject}))
	else
		console.log "no comm pref"
		console.log err
				

sendEmails = (volunteers,body,subject)->	
	console.log("Sending emails...")
	Host.
	findOne {'service':'MailGun'}, (err,host)->
		console.log("Connected to mail service")
		smtpTransport = nodemailer.createTransport 'SMTP',
			service: "Mailgun"
			auth:
				user:host.user,
				pass:host.pass
		for volunteer in volunteers
			console.log(volunteer.Email)
			body = jsontemplate.string(body,volunteer)
			subject = jsontemplate.string(subject,volunteer)
			smtpTransport.sendMail {
				from:"durhamteam7@gmail.com",
				to:volunteer.Email,
				subject:subject,
				text:body#,
					###attachments:[{
						filename:'filename.pdf',
						filePath:serverUrl+'URL OF FILE'
					}]###
			},(err,response)->
				if err
					console.log err

router.get '/genPdf/:obj', (req,res)->
	console.log("genPDF route")
	data = JSON.parse decodeURIComponent req.params.obj
	console.log(data)
	volunteersFormatted = []
	for volunteer in data.volunteers
		v = {"body":jsontemplate.string(data.body,volunteer), "subject": jsontemplate.string(data.subject,volunteer), "address":volunteer.Address}
		volunteersFormatted.push v
	#subject = "RE: Review of Volunteer Details"
	#body = "Dear Simon,\n\nWear Rivers Trust want to ensure that all volunteer records we keep is valid and upto date to help us achieve this we will contact every two years to review this information. Please contact Diane Maughan to inform her of any changes required and to confirm that you want to remain on our contact data base as a volunteer. \n\nIf you do not contact us within 2 months we will assume our records are incorrect or that you no longer want to volunteer for the trust. We will then suspend you application for 6 months after that period all information we hold about you will destroyed. \n\nI would like to thank you on behalf of the Trustees and Staff for choosing to donate your time this is in invaluable to us and the environment.\n\nYours Sincerely\n\n\n\nDiane Maughan\nOffice Manager"

	require("./genPDF.coffee")(req,res,volunteersFormatted)

module.exports = router
