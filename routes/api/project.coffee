express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Project = mongoose.model 'Project'
User = mongoose.model 'User'

ObjId = mongoose.Types.ObjectId


router.get '/', (req,res)->
	console.log("getting")
	try
		Project.
		find().
		exec (err, project)->
			if err
				return console.log err
			try
				res.json project
			catch
				res.json {'error':'no sites found'}
	catch
		res.redirect '/404.htm'

router.get '/:id', (req,res)->
	try
		Project.
		findById(req.params.id).
		exec (err, project)->
			if err
				return console.log err
			try
				console.log("JSONing")
				res.json project.toJSON()
			catch
				res.json {'error':'site not found'}
	catch
		res.redirect '/404.htm'


router.post '/', (req,res)->	#CREATE
	console.log "Making new project"
	project = new Project()
	project.save (err)->
		if !err
			res.json project.toJSON()


router.patch '/:id',(req,res)->
	Project.
	findById(req.params.id).
	exec (err,project)->
		if err
			res.json err
		else if project == null
			res.send 404
		else
			project = recurseUpdate(project,req.body) #see function def below
			project.save (err)->
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
	Project.
	findById(req.params.id).
	exec (err,project)->
		if err
			res.json err
		else if site == null
			res.sendStatus 404
		else
			Project.findByIdAndRemove project._id, (err)->
				if err
					console.log err
			res.sendStatus 204

module.exports = router
