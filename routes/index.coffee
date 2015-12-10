express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
Volunteer = mongoose.model 'Volunteer'
User = mongoose.model 'User'


#Serving up HTML documents

router.get '/',(req,res,next)->
	res.redirect '/dash'


# GET dash.
router.get '/dash', (req, res, next) ->
	Volunteer.
	find('name').
	exec (err,volunteers)->
		res.render 'template',
			content:'dash',
			volunteer:volunteers
			###username:req.user.username###


router.get '/template', (req, res, next) ->
	res.render 'template',
		content:'blank'
		#username:req.user.username

router.get '/volunteer/new', (req,res,next) ->
	newVolunteer = new Volunteer()
	newVolunteer.save (err) ->
		if err
			console.log err
		res.redirect '/volunteer/'+newVolunteer._id

#Route to make new users
###router.get '/user/new', (req,res,next) ->
	userJson = {username:"admin"}
	console.log(userJson)
	user = new User(userJson)
	userJson.hash=user.generateHash "admin"
	console.log(userJson)
	newUser = new User(userJson)
	console.log newUser
	newUser.save (err) ->
		if err
			console.log err
		res.redirect '/api/user/'+newUser._id###

# GET template.
router.get '/volunteer/:id', (req, res, next) ->
	Volunteer.
	findById(req.params.id).
	exec (err,volunteer)->
		res.render 'template',
			content:'site',
			volunteerId:req.params.id,
			#username:req.user.username,
			volunteer:volunteer


router.post '/receiveajax', (req,res,next)->
	receivedData = req.body
	res.send 'Thanks for the data!'

module.exports = router
