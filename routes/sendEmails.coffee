#Sends an email to a list of volunteers
mongoose = require 'mongoose'
nodemailer = require 'nodemailer'

Host = mongoose.model 'Host'
jsontemplate = require 'json-templater'


module.exports = (volunteers,body,subject)->	
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
