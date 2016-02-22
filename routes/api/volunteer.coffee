express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Volunteer = mongoose.model 'Volunteer'
User = mongoose.model 'User'

ObjId = mongoose.Types.ObjectId

WELCOME_SUBJECT = "RE: Registration as a volunteer"
WELCOME_BODY = "Dear {{First_Name}} {{Last_Name}}\n\nOn behalf of the Trustees I would like to welcome you to Wear Rivers Trust, your volunteer application has been successfully registered.\n\nWe will notify you of any up and coming volunteering opportunities and training events that you have expressed an interest in pursuing.\n\nI would like to thank you for choosing to donate your time; this is in invaluable to us and the environment and look forward to working with you in the future.\n\nYours Sincerely\n\n\n\nDiane Maughan\nOffice Manager\n\n"

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
            require("../sendCommunication.coffee")("commPref",WELCOME_BODY,WELCOME_SUBJECT,[volunteer])
            res.json volunteer

#NEEDED?
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
			vEmail = volunteer.Email
			volunteer = recurseUpdate(volunteer,req.body) #see function def below
			volunteer.save (err)->
				if err
					console.log err
					res.status 500
					return err
				if(typeof vEmail == "undefined" && typeof req.body.Email != "undefined")
					#if new volunteer
					#send email
					console.log("New Volunteer")
					require("../sendCommunication.coffee")("commPref",WELCOME_BODY,WELCOME_SUBJECT,[volunteer])

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
