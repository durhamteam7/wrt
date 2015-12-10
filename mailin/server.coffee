###mailin = require 'mailin'

mailin.start {
    port:3001,
    disableWebHook:true,
    smtpOptions:
        banner:'Email Things',
        disableDNSValidation:true,
        name:'email.address.com',
    logLevel:'silly'
}


mailin.on 'startMessage', (connection)->
    console.log 'yo'
    console.log connection


mailin.on 'message', (connection, data, content)->
    console.log 'yo'

    console.log data

    console.log connection

    console.log content###
