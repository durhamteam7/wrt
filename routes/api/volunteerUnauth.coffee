express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Volunteer = mongoose.model 'Volunteer'
User = mongoose.model 'User'

ObjId = mongoose.Types.ObjectId


router.post '/', (req,res)->	#CREATE
	console.log(req.body)
	console.log "Making new volunteer from signup form"
	volunteer = new Volunteer(req.body)
	volunteer["approved"] = false
	volunteer.save (err)->
		if !err
			res.redirect "../thankYou.html?name="+volunteer['First_Name']


module.exports = router