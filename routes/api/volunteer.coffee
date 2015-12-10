express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Volunteer = mongoose.model 'Volunteer'
User = mongoose.model 'User'

ObjId = mongoose.Types.ObjectId

#Site API for Angular

router.get '/', (req,res)->
	try
		Volunteer.
		find().
		exec (err, volunteer)->
			if err
				return console.log err
			try
				res.json volunteer
			catch
				res.json {'error':'no sites found'}
	catch
		res.redirect '/404.htm'

router.get '/:id', (req,res)->
	try
		Volunteer.
		findById(req.params.id).
		exec (err, volunteer)->
			if err
				return console.log err
			#console.log("req.user",req.user)

			try
				console.log("JSONing")
				res.json volunteer.toJSON()
			catch
				res.json {'error':'site not found'}
	catch
		res.redirect '/404.htm'


router.post '/', (req,res)->	#CREATE
	console.log "Making new volunteer"
	volunteer = new Volunteer()
	volunteer.save (err)->
		if !err
			res.json volunteer.toJSON()


router.patch '/:id',(req,res)-> #This is slower than the commented out version but it does what I want it to...
	Volunteer.
	findById(req.params.id).
	exec (err,volunteer)->
		if err
			res.json err
		else if volunteer == null
			res.send 404
		else
			volunteer = recurseUpdate(site,req.body) #see function def below
			volunteer.save (err)->
				if err
					console.log err
					res.status 500
					return err
				res.json {'message':'Object updated'}

recurseUpdate = (obj,diff)->				
	#Loop through key value pairs, if value is an object recurse else update values
	for key, value of diff
		if (typeof value) == 'object' && (typeof obj[key]) == 'object' #(Naively) just assumes 'object' type is key-value pairs
			obj[key] = recurseUpdate(obj[key],value)
		else
			obj[key] = value
	return obj
#

router.delete '/:id', (req,res,next)->	#DELETE
	Volunteer.
	findById(req.params.id).
	exec (err,volunteer)->
		if err
			res.json err
		else if site == null
			res.sendStatus 404
		else
			Volunteer.findByIdAndRemove volunteer._id, (err)->
				if err
					console.log err
			res.sendStatus 204

module.exports = router
