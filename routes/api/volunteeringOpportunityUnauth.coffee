express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Volunteering_Opportunity = mongoose.model 'Volunteering_Opportunity'
User = mongoose.model 'User'
ObjId = mongoose.Types.ObjectId


router.get '/', (req,res)->
	console.log Volunteering_Opportunity
	try
		Volunteering_Opportunity.
		find().
		exec (err, volunteeringOpportunity)->
			console.log volunteeringOpportunity
			if err
				return console.log err
			try
				res.json volunteeringOpportunity
			catch
				res.json {'error':'no sites found'}
	catch
		res.redirect '/404.htm'

module.exports = router