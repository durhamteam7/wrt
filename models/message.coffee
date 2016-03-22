mongoose = require 'mongoose'
ttl = require 'mongoose-ttl'
Schema = mongoose.Schema

messageCore =
	subject: String,
	body: String,
	volunteersEmail: Object,
	volunteersLetter: Object,
	volunteersTel: Object,
	emailSent:
		type:Boolean,
		default:false,
	letterSent:
		type:Boolean,
		default:false,
	telSent:
		type:Boolean,
		default:false,





Message = new Schema messageCore,{timestamps: true}


#Remove message after a week
Message.plugin(ttl, { ttl: '7d' , interval:'1d'});
Cache = mongoose.model('Cache', Message);
Cache.startTTLReaper();



Message.set 'toObject', { virtuals: true }
Message.set 'toJSON', {getters:true,virtuals:true}	

Message.virtual('letterURL').get ->
	return 'email/genPdf/'+encodeURIComponent(JSON.stringify({'volunteers':this.volunteersLetter,'body':this.body,'subject':this.subject}))

Message.virtual('emailList').get ->
	return 'email/genEmailList/'+encodeURIComponent(JSON.stringify(this.volunteersEmail))

Message.virtual('telephoneList').get ->
	return 'email/genTelephoneList/'+encodeURIComponent(JSON.stringify({'volunteers':this.volunteersTel,'body':this.body,'subject':this.subject}))



Message.virtual('createdAtPretty').get ->
	date = this.createdAt
	return date.toLocaleString();



mongoose.model 'Message',Message
