express = require 'express'
router = express.Router()
mongoose = require 'mongoose'

Volunteer = mongoose.model 'Volunteer'
User = mongoose.model 'User'
nodemailer = require 'nodemailer'
Host = mongoose.model 'Host'

ObjId = mongoose.Types.ObjectId


recurseUpdate = (obj,diff)->				#Loop through key value pairs, if value is an object recurse else update values
	for key, value of diff
		if (typeof value) == 'object' && (typeof obj[key]) == 'object' #(Naively) just assumes 'object' type is key-value pairs
			obj[key] = recurseUpdate(obj[key],value)
		else
			obj[key] = value
	return obj


router.post '/:info?', (req,res,next)->	#CREATE
	deets = if req.params.info then JSON.parse(encodeURIComponent(req.params.info)) else req.body
	delete deets._id
	console.log deets
	user = new User deets
	setPassword(deets,user)
	user.save (err)->
		if err
			console.log err
		res.redirect '/dash'

#
router.get '/:id?', (req,res,next)->	#READ
	if req.params&&req.params.id&&req.params.id.match /^[0-9a-fA-F]{24}$/
		User.
		findById(req.params.id).
		exec (e,user)->
			if e
				return next e
			res.json user
#
router.patch '/:info?', (req,res,next)->	#UPDATE
	deets = if req.params.info then JSON.parse(encodeURIComponent(req.params.info)) else req.body
	User.
	findById(deets.id).
	exec (e,user)->
		if deets.password					#Send a password email to user
			setPassword(deets,user)
		user = recurseUpdate(user,deets)
		user.save (e)->
			if e
				console.log e
		res.redirect '/dash'
#
###router.delete '/:id', (req,res,next)->	#DELETE
	if req.user.isAdmin
		CsiStaff.
		findById(req.params.id).
		exec (err,staff)->
			if err
				res.json err
			else if req.user.company != csiId || staff.company == req.user.company
				staff.remove()
			else
				res.json {'go_away':"You aren't in that company!"}
	else
		res.json {'go_away':"You aren't admin!"}###
#


setPassword = (deets,user)->
	pw=''
	for i in [0..8]
		pw+='qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890'[Math.floor Math.random()*62]
	deets.hash=user.generateHash pw
	Host.
	findOne {'service':'sendemail'}, (err,host)->
		smtpTransport = nodemailer.createTransport 'SMTP',{
			host:host.host,
			auth:
				user:host.user,
				pass:host.pass
		}
		smtpTransport.sendMail {
			from:host.sender,
			to:deets.email,
			subject:'Your new password',
			text:'Hello '+deets.firstName+'!  Your new password is '+pw
		},(err,response)->
			if err
				console.log err
			pw = 'XXXXXXXXXXXXXXXXXXXX'
			pw = undefined

module.exports = router
