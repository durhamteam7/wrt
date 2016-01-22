
#Code to send out emails 

express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
nodemailer = require 'nodemailer'
Host = mongoose.model 'Host'
fs = require 'fs'
Volunteer = mongoose.model 'Volunteer'

serverUrl = process.env.SERVERURL || 'http://localhost:3000'

#Routes here prefixed by /email/

router.post '/', (req,res)->
	console.log("emailing")
	Host.
	findOne {'service':'MailGun'}, (err,host)->
		smtpTransport = nodemailer.createTransport 'SMTP',
			service: "Mailgun"
			auth:
				user:host.user,
				pass:host.pass 
		console.log (req.body.select[0])
		for volunteer in req.body.select
			console.log(volunteer)
			smtpTransport.sendMail {
				from:"durhamteam7@gmail.com",
				to:volunteer.email,
				subject:req.body.subject,
				text:req.body.body#,
				###attachments:[{
					filename:'filename.pdf',
					filePath:serverUrl+'URL OF FILE'
				}]###
			},(err,response)->
				if err
					console.log err
	res.sendStatus 200



module.exports = router
