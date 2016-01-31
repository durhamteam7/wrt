mongoose = require 'mongoose'
Schema = mongoose.Schema

messageCore =
	subject: String,
	body: String,
	commPref:String

Message = new Schema messageCore,timestamps: true

mongoose.model 'Message',Message
