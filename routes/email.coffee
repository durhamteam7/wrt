
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
	actualSiteString = ''
	Host.
	findOne {'service':'MailGun'}, (err,host)->

		smtpTransport = nodemailer.createTransport 'SMTP',
			service: "Mailgun"
			auth:
				user:host.user,
				pass:host.pass
		#console.log serverUrl+'/jsonpdfgen/quote/'+req.params.time+'/'+actualSiteString
		smtpTransport.sendMail {
			from:"durhamteam7@gmail.com",
			to:"durhamteam7@gmail.com",
			subject:'WRT test',
			text:'This is just a test email'#,
			###attachments:[{
				filename:'quote.pdf',
				filePath:serverUrl+'/jsonpdfgen/quote/'+req.params.time+'/'+actualSiteString
			}]###
		},(err,response)->
			if err
				console.log err
	#res.redirect '/site/'+req.params.id



module.exports = router
