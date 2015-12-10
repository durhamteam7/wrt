
#For connection to external services

mongoose = require 'mongoose'
Schema = mongoose.Schema

Host = new Schema(
	service:String,
	sender:String,
	host:String,
	user:String,
	pass:String,
	region:String,
	accesskeyid:String,
	secretaccesskey:String
)

mongoose.model 'Host', Host