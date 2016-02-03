#Send renewal message

console.log("cron begun")

RENEWAL_YEARS = 2
RENEWAL_MONTHS = 0
RENEWAL_DAYS = 0

RENEWAL_SUBJECT = "RE: Review of Volunteer Details"
RENEWAL_BODY = "Dear {{First_Name}} {{Last_Name}}\n\nWear Rivers Trust want to ensure that all volunteer records we keep is valid and upto date to help us achieve this we will contact every two years to review this information. Please contact Diane Maughan to inform her of any changes required and to confirm that you want to remain on our contact data base as a volunteer.\n\nIf you do not contact us within 2 months we will assume our records are incorrect or that you no longer want to volunteer for the trust. We will then suspend you application for 6 months after that period all information we hold about you will destroyed.\n\nI would like to thank you on behalf of the Trustees and Staff for choosing to donate your time this is invaluable to us and the environment.\n\nYours Sincerely\n\n\n\nDiane Maughan\nOffice Manager"

schedule = require('node-schedule')
mongoose = require 'mongoose'
Volunteer = mongoose.model 'Volunteer'
 
rule = new schedule.RecurrenceRule()
#rule.second = [0, new schedule.Range(0,59,30)]
rule.hour = 1
 
j = schedule.scheduleJob(rule, ()->
	console.log('Begun renewal message generation')
	today = new Date()
	compDate1 = new Date(today.getUTCFullYear()-RENEWAL_YEARS,today.getMonth()-RENEWAL_MONTHS,today.getDay()-RENEWAL_DAYS)
	compDate2 = new Date(compDate1.getUTCFullYear(),compDate1.getMonth(),compDate1.getDay()+1)
	console.log(compDate1,compDate2)
	Volunteer.find({"createdAt": {"$gte": compDate1, "$lt": compDate2}}).
	exec (err, volunteers)->
		if volunteers.length > 0
			console.log("Sending autoRenew messages...")
			console.log(volunteers)
			forLetter = []
			forEmail = []
			forTelephone = []

			for v in volunteers
				if v.Communication_Preference == "Email"
					forEmail.push v
				else if v.Communication_Preference == "Letter"
					forLetter.push v
				else if v.Communication_Preference == "Telephone"
					forTelephone.push v
				else
					console.log("Unknown comm pref...")
			console.log("Email",forEmail)
			console.log("letter",forLetter)
			console.log("forTelephone",forTelephone)
			if forEmail.length > 0
				require("./sendEmails.coffee")(forEmail,RENEWAL_BODY,RENEWAL_SUBJECT)
			if forLetter.length > 0
				console.log "email/genPdf/"+encodeURIComponent(JSON.stringify({"volunteers":forLetter,"body":RENEWAL_BODY,"subject":RENEWAL_SUBJECT}))

		else
			console.log "No volunteers to renew"
)