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
	find('First_Name').
	exec (err,volunteers)->
		res.render 'template',
			content:'dash'
			userID: req.user._id
			#username:req.user.username



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


router.post '/receiveajax', (req,res,next)->
	receivedData = req.body
	res.send 'Thanks for the data!'

module.exports = router
