module.exports =
	'secret': process.env.secret || 'verylongsecretnameherewhichweshouldnotrevealandchangeforproduction',
	'ENV' : process.env.ENV || 'dev',
	'mongoDB' : process.env.dbURL || 'mongodb://wrt:electrofish@ds051595.mongolab.com:51595/wrtdev'