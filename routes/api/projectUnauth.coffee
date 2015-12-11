express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Project = mongoose.model 'Project'
User = mongoose.model 'User'
ObjId = mongoose.Types.ObjectId



router.get '/', (req,res)->
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

module.exports = router