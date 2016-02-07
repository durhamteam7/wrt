express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Volunteering_Opportunity = mongoose.model 'Volunteering_Opportunity'
User = mongoose.model 'User'
ObjId = mongoose.Types.ObjectId


router.get '/', (req,res)->
	console.log("getting")
	try
		Volunteering_Opportunity.
		find().
		exec (err, volunteeringOpportunity)->
			if err
				return console.log err
			try
				res.json volunteeringOpportunity
			catch
				res.json {'error':'no sites found'}
	catch
		res.redirect '/404.htm'

router.get '/:id', (req,res)->
	try
		Volunteering_Opportunity.
		findById(req.params.id).
		exec (err, volunteeringOpportunity)->
			if err
				return console.log err
			try
				console.log("JSONing")
				res.json volunteeringOpportunity.toJSON()
			catch
				res.json {'error':'site not found'}
	catch
		res.redirect '/404.htm'


router.post '/', (req,res)->	#CREATE
	console.log "Making new volunteeringOpportunity"
	volunteeringOpportunity = new Volunteering_Opportunity()
	volunteeringOpportunity.save (err)->
		if !err
			res.json volunteeringOpportunity.toJSON()


router.patch '/:id',(req,res)->
	Volunteering_Opportunity.
	findById(req.params.id).
	exec (err,volunteeringOpportunity)->
		if err
			res.json err
		else if volunteeringOpportunity == null
			res.send 404
		else
			volunteeringOpportunity = recurseUpdate(volunteeringOpportunity,req.body) #see function def below
			volunteeringOpportunity.save (err)->
				if err
					console.log err
					res.status 500
					return err
				res.json {'message':'Object updated'}

recurseUpdate = (obj,diff)->				
	#Loop through key value pairs, if value is an object recurse else update values
	for key, value of diff
		console.log key,value
		if (typeof value) == 'object' && (typeof obj[key]) == 'object' #(Naively) just assumes 'object' type is key-value pairs
			obj[key] = recurseUpdate(obj[key],value)
		else
			obj[key] = value
	return obj
#

router.delete '/:id', (req,res,next)->	#DELETE
	Volunteering_Opportunity.
	findById(req.params.id).
	exec (err,volunteeringOpportunity)->
		if err
			res.json err
		else if site == null
			res.sendStatus 404
		else
			Volunteering_Opportunity.findByIdAndRemove volunteeringOpportunity._id, (err)->
				if err
					console.log err
			res.sendStatus 204

module.exports = router
