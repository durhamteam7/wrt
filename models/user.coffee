mongoose = require 'mongoose'
Schema = mongoose.Schema

bcrypt   = require 'bcrypt-nodejs'

userCore =
	username: String,
	email: String,
	hash: String,
	tableHeadings: [String]

User = new Schema userCore

#generating a hash
User.methods.generateHash = (password) ->
	return bcrypt.hashSync password

#checking if password is valid
User.methods.validPassword = (password) ->
	console.log 'Checking login details'
	return bcrypt.compareSync password,this.hash

mongoose.model 'User', User
