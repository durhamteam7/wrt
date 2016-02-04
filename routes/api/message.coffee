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


module.exports = router