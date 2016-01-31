mongoose = require 'mongoose'
Schema = mongoose.Schema

settingsCore =
	Letter:
		Header: String,
		Footer: String
	Email_Address: String,
	Message_On_Signup:{type:Schema.Types.ObjectId,ref:'Message'},
	Message_On_Renewal:{type:Schema.Types.ObjectId,ref:'Message'},
	Renewal_Period: Number


Settings = new Schema settingsCore

mongoose.model 'Settings',Settings
