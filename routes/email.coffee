
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

router.post '/toheads/:time/:id', (req,res)->
	Volunteer.
	findById(req.params.id).
	exec (err,site)->
		actualSiteString = ''
		site.quotes.quotes.forEach (snapshot)->
			#console.log snapshot.sentOut
			if snapshot.sentOut==parseInt req.params.time
				actualSiteString = encodeURIComponent snapshot.siteSnapshot
		Host.
		findOne {'service':'sendemail'}, (err,host)->
			smtpTransport = nodemailer.createTransport 'SMTP',
				host:host.host,
				auth:
					user:host.user,
					pass:host.pass
			console.log serverUrl+'/jsonpdfgen/quote/'+req.params.time+'/'+actualSiteString
			smtpTransport.sendMail {
				from:host.sender,
				to:req.body.email,
				subject:'CSI quotation',
				text:'The quotation can be found attached',
				attachments:[{
					filename:'quote.pdf',
					filePath:serverUrl+'/jsonpdfgen/quote/'+req.params.time+'/'+actualSiteString
				}]
			},(err,response)->
				if err
					console.log err
				prevSentVersion = {timeQuoteCreated:req.params.time,timeSentOut:Date.now(),email:req.body.email,siteName:site.information.name}
				site.quotes.previouslySentVersions.push(prevSentVersion)
				console.log("start")
				site.save (err)->
					console.log("end")
					if err
						console.log err
						return err
			res.redirect '/site/'+req.params.id



module.exports = router
