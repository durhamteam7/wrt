express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
ObjId = mongoose.Types.ObjectId
urls = require '../../config/urls.coffee'
backup = require 'mongodb-backup'
restore = require 'mongodb-restore'
Busboy = require 'busboy'
Volunteer = mongoose.model 'Volunteer'

router.get '/test', (req,res,next)->	#READ
	console.log("Hi")

router.get '/', (req,res,next)->	#READ
	console.log "start"
	res.writeHead(200, {
    	'Content-Type': 'application/x-tar',
    	'Content-Disposition': "attachment;filename=" + "backup - "+Date.now()+".tar"
  	});

	#DB BACKUP
	backup({
	  uri: urls.mongoDB,
	  stream: res
	})

router.post '/', (req,res)->	#READ
	console.log "start"
	busboy = new Busboy {headers:req.headers}
	busboy.on 'file', (fieldname,file,fileName,encoding,mimeType)->
		console.log("file")
		console.log fieldname,file,fileName,encoding,mimeType
		#DB BACKUP
		restore({
		  uri: urls.mongoDB,
		  drop: !req.drop,
		  stream: file
		})

	busboy.on 'finish', ->
		console.log("Backup uploaded")
		res.redirect "/"
	req.pipe busboy



module.exports = router