express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
Busboy = require 'busboy'
Grid = require 'gridfs-stream'
Volunteer = mongoose.model 'Volunteer'



#Code to store images in database


router.post '/siteimg/create/:id', (req,res)->
	gfs = Grid mongoose.connection.db, mongoose.mongo
	gfs.remove({filename:req.params.id},(err)->
		if err
			return err
		)
	busboy = new Busboy {headers:req.headers}
	busboy.on 'file', (fieldname,file,fileName,encoding,mimeType)->

		#options = {filename : filename}; #can be done via _id as well

		ws = gfs.createWriteStream(
			mode: 'w',
			content_type: mimeType,
			filename: req.params.id,
			metadata: {h8client: "csisolar"}

		)
		file.pipe ws

	busboy.on 'finish', ->
		res.redirect '/site/'+req.params.id
	req.pipe busboy

router.get '/siteimg/read/:id', (req,res)->
	gfs = Grid mongoose.connection.db, mongoose.mongo
	gfs.
	createReadStream({filename:req.params.id}).
	on('error', (err)->
		res.send err
	).pipe res



router.post '/create/:keyInObj/:id', (req,res)->	#All files uniquely determined by timestamp+siteid
	keyInObj = decodeURIComponent(req.params.keyInObj).split '.'
	createdTime = (new Date()).getTime()
	gfs = Grid mongoose.connection.db, mongoose.mongo
	gfs.remove({filename:createdTime+req.params.id},(err)->
		if err
			return err
		)
	busboy = new Busboy {headers:req.headers}
	busboy.on 'file', (fieldname,file,fileName,encoding,mimeType)->
		theFileName = fileName

		#options = {filename : filename}; #can be done via _id as well

		ws = gfs.createWriteStream(
			mode: 'w',
			content_type: mimeType,
			filename: createdTime+req.params.id,
			metadata: {h8client: "csisolar"}

		)
		file.pipe ws

	busboy.on 'finish', ->
		res.redirect '/site/'+req.params.id
	req.pipe busboy
	Volunteer.
	findById(req.params.id).
	exec (err,site)->
		if err
			return err
		bitToChange = site
		for key in keyInObj
			bitToChange = bitToChange[key]
		bitToChange.push createdTime
		site.
		save (err)->
			if err
				return err

router.get '/read/:name', (req,res)->
	gfs = Grid mongoose.connection.db, mongoose.mongo
	gfs.
	createReadStream({filename:req.params.name}).
	on('error', (err)->
		res.send err
	).pipe res













module.exports = router