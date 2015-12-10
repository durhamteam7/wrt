#Allows client-side access to the Schemas for client-side validation

express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
schemas=
	user:'./models/user.coffee'
	volunteer:'./models/volunteer.coffee'

router.get '/:model',(req,res)->
	res.sendFile schemas[req.params.model],{root:__dirname+"../../.."}

module.exports = router

