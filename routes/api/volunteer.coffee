express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Volunteer = mongoose.model 'Volunteer'
User = mongoose.model 'User'

ObjId = mongoose.Types.ObjectId


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

router.get '/unapproved', (req,res)->
	try
		Volunteer.
		find({ Approved: {$in: [null, false]} }).
		exec (err, volunteer)->
			if err
				return console.log err
			try
				res.json volunteer
			catch
				res.json {'error':'no sites found'}
	catch
		res.redirect '/404.htm'

router.get '/approved', (req,res)->
	try
		Volunteer.
		find({ Approved: true }).
		exec (err, volunteer)->
			if err
				return console.log err
			try
				res.json volunteer
			catch
				res.json {'error':'no sites found'}
	catch
		res.redirect '/404.htm'

router.patch '/approve/:id',(req,res)->
    console.log("approving", req.params.id)
    Volunteer.
    findById(req.params.id).
    exec (err, volunteer)->
        console.log(volunteer)
        if err
            return console.log err
        else
            volunteer["Approved"] = true
            volunteer.save (err)->
            if err
                console.log err
                res.status 500
                return err
            res.json volunteer

router.patch '/unapprove/:id',(req,res)->
    console.log("unapproving", req.params.id)
    Volunteer.
    findById(req.params.id).
    exec (err, volunteer)->
        console.log(volunteer)
        if err
            return console.log err
        else
            volunteer["Approved"] = false
            volunteer.save (err)->
            if err
                console.log err
                res.status 500
                return err
            res.json volunteer

router.get '/:id', (req,res)->
	try
		Volunteer.
		findById(req.params.id).
		exec (err, volunteer)->
			if err
				return console.log err
			try
				console.log("JSONing")
				res.json volunteer.toJSON()
			catch
				res.json {'error':'site not found'}
	catch
		res.redirect '/404.htm'


router.post '/approve', (req,res)->	#CREATE APPROVED VOLUNTEER
	console.log "Making new approved volunteer"
	volunteer = new Volunteer()
	volunteer["Approved"] = true
	console.log(volunteer)
	volunteer.save (err)->
		if !err
			res.json volunteer.toJSON()

router.post '/unapprove', (req,res)->	#CREATE UNAPPROVED VOLUNTEER
	console.log "Making new unapproved volunteer"
	volunteer = new Volunteer()
	volunteer["Approved"] = false
	console.log(volunteer)
	volunteer.save (err)->
		if !err
			res.json volunteer.toJSON()

router.post '/', (req,res)->	#CREATE
	console.log "Making new volunteer"
	volunteer = new Volunteer()
	volunteer.save (err)->
		if !err
			res.json volunteer.toJSON()


router.patch '/:id',(req,res)->
	console.log("modifying",req.params.id)
	Volunteer.
	findById(req.params.id).
	exec (err,volunteer)->
		if err
			res.json err
		else if volunteer == null
			res.send 404
		else
			volunteer = recurseUpdate(volunteer,req.body) #see function def below
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
		else if volunteer == null
			res.sendStatus 404
		else
			Volunteer.findByIdAndRemove volunteer._id, (err)->
				if err
					console.log err
			res.sendStatus 204

module.exports = router
