mongoose = require 'mongoose'
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
	expireAt:
	    type: Date,
	    default: ()->
        	return new Date(new Date().valueOf() + 60*60*24*7)




Message = new Schema messageCore,{timestamps: true}

Message.index({ expireAt: 1 }, { expireAfterSeconds : 0 })

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
