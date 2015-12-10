express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
Volunteer = mongoose.model 'Volunteer'


# GET home page.
router.get '/login', (req, res, next) ->
	res.render 'template',
		content:'login'


module.exports = router
