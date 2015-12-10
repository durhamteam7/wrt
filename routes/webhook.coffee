#staff route

express = require 'express'
router = express.Router()
mongoose = require 'mongoose'
User = mongoose.model 'User'

router.get '/',(req,res)->
	res.json {}

router.post '/',(req,res)->
	res.json {}



module.exports = router
