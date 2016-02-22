express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Message = mongoose.model 'Message'

# GET all messages.
router.get '/', (req,res)->
	try
		Message.
		find().
		exec (err, message)->
			if err
				return console.log err
			try
				res.json message
			catch
				res.json {}
	catch
		res.redirect '/404.htm'


#GET number of unread messages
router.get '/unsent', (req,res)->
	mainCount = 0
	Message.$where('!this.emailSent && typeof(this.volunteersEmail) !== "undefined" && this.volunteersEmail.length!=0').count()
	.exec (err, count) ->
		mainCount += count
		Message.$where('!this.letterSent && typeof(this.letterSent) !== "undefined" && this.volunteersLetter.length!=0').count()
		.exec (err, count) ->
			mainCount += count
			Message.$where('!this.telSent && typeof(this.telSent) !== "undefined" && this.volunteersTel.length!=0').count()
			.exec (err, count) ->
				mainCount += count
				res.json mainCount


router.patch '/sendTelephone/:id', (req,res)->
	Message.
	findById(req.params.id).
	exec (e,message)->
		if e
			return next e
		message.telSent = true
		message.save()
		res.json message

router.patch '/sendLetter/:id', (req,res)->
	Message.
	findById(req.params.id).
	exec (e,message)->
		if e
			return next e
		message.letterSent = true
		message.save()
		res.json message

router.patch '/sendEmail/:id', (req,res)->
	Message.
	findById(req.params.id).
	exec (e,message)->
		if e
			return next e
		message.emailSent = true
		message.save()
		res.json message

module.exports = router