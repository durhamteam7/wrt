express = require 'express'
#			Basic Express stuff
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'


session = require 'express-session'




#Database, user login stuff
mongoose = require 'mongoose'



urls = require './config/urls.coffee'

#Connect to the DB

mongoose.connect urls.mongoDB

#Define our models

require './models/host.coffee'
require './models/user.coffee'
require './models/volunteer.coffee'
require './models/project.coffee'
User = mongoose.model 'User'

#Mailin server

#require './mailin/server.coffee'


app = express()


#Configuring Passport stuff for login
passport = require('passport')
LocalStrategy = require('passport-local').Strategy



app.all '*', (req, res, next) ->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS'
	res.header 'Access-Control-Allow-Headers', 'Content-Type'
	next()


#view engine setup
#for ejs which allows us to use ejs files as templates
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'ejs'


#uncomment after placing your favicon in /static
#app.use favicon __dirname + '/static/favicon.ico'

#PASSPORT SECURITY THINGS
passport.serializeUser (user, done)->
	done null, user


passport.deserializeUser (user, done)->
	done null, user


passport.use new LocalStrategy (username, password, done)->
	console.log 'Checking stuff'
	process.nextTick ->
		User.findOne({ username: username }, (err, staff)->

			if err
				return done(err)

			if !staff || !(staff.validPassword password, staff.hash)
				console.log "Incorrect user details"
				return done null, false, { message: 'Incorrect username/password.' }

			return done null, staff
		)


app.use session
	secret:'verylongsecretnameherewhichweshouldnotrevealandchangeforproduction'
	resave: true,
	saveUninitialized: true

app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })
app.use cookieParser()
app.use express.static('static')
app.use passport.initialize()
app.use passport.session()

#Login - no authentication to get here
app.use '/',require('./routes/login.coffee')

#Allows Volunteer signup form to access project data without auth
app.use '/api/projectUnauth',require('./routes/api/projectUnauth.coffee')

#Allows Volunteer signup form to create new volunteers without auth
app.use '/api/volunteerUnauth',require('./routes/api/volunteerUnauth.coffee')

#app.use '/jsonpdfgen', require('./routes/pdf/unauthquotepdf.coffee') #another un-auth route

app.use '/logout', require('./routes/logout.coffee')

app.post '/loginauth', passport.authenticate('local',
	{
		failureRedirect: '/login',
		passReqToCallback : true
	}),(req, res)->
	console.log 'Passed login Middleware'
	res.redirect '/'

app.use '/webhook', require('./routes/webhook.coffee')



app.all '*', (req,res,next)->

	#Here we sort out the method if it's been botched on the client side via the inclusion of a _method key in the body:
	#Deals with PATCH methods
	if req.body&&req.body._method
		req.method = req.body._method.toUpperCase()
		delete req.body._method
	else if req.params&&req.params._method
		req.method = req.params._method.toUpperCase()
		delete req.params._method

	#Here we do our authentication
	if req.isAuthenticated()
		return next()
	res.redirect '/login'

Volunteer = mongoose.model 'Volunteer'


app.use '/', require('./routes/index.coffee') #routing file for HTML

#MAIN ROUTES for API
app.use '/api/user', require('./routes/api/user.coffee')

app.use '/api/schemas', require('./routes/api/schemas.coffee')

app.use '/api/volunteer', require('./routes/api/volunteer.coffee')

app.use '/api/project', require('./routes/api/project.coffee')


app.use '/gridfs', require('./routes/gridfs.coffee')

app.use '/email', require('./routes/email.coffee')


# catch 404 and forward to error handler
app.use (req, res, next) ->
	err = new Error 'Not Found'
	err.status = 404
	next err

#error handlers

# development error handler
#will print stacktrace
if app.get('env') == 'development'
	app.use (err, req, res, next) ->
		res.status err.status || 500
		message: err.message,
		error: err

# production error handler
# no stacktraces leaked to user
#app.use (err, req, res, next) ->
	#res.redirect '/404.htm'
	 #res.status err.status || 500
	 #res.render 'error',
	 #	message: err.message,
	 #	error: {}

module.exports = app
