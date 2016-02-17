express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
jsontemplate = require 'json-templater'

fs = require 'fs'
Volunteer = mongoose.model 'Volunteer'
Message = mongoose.model 'Message'

serverUrl = process.env.SERVERURL || 'http://localhost:3000'


module.exports =  (communicationType,body,subject,volunteers) ->
	console.log("got here")
	console.log("Sending communications")
	console.log(communicationType)
	#Save message in db
	message = new Message {body:body,subject:subject,commPref:communicationType}

	if communicationType == "commPref"
		forLetter = []
		forEmail = []
		forPhone = []

		for v in volunteers
			if v.Communication_Preference == "Email"
				forEmail.push v
			else if v.Communication_Preference == "Letter"
				forLetter.push v
			else if v.Communication_Preference == "Telephone"
				forPhone.push v
			else
				console.log("Unknown comm pref...")

		message.volunteersEmail = forEmail
		require("./sendEmails.coffee")(forEmail,body,subject)
		message.volunteersLetter = forLetter
		message.volunteersTel = forPhone

	else if communicationType == "Email"
		message.volunteersEmail = volunteers
		require("./sendEmails.coffee")(volunteers,body,subject)
	else if communicationType == "Letter"
		console.log("Force letter")
		message.volunteersLetter = volunteers
	else if communicationType == "Telephone"
		message.volunteersTel = volunteers
	else
		console.log "no comm pref"
		console.log err

	console.log(message)

	message.save (err)->
		if err
			console.log err
		else
			console.log "Saved in db"