PDFDocument = require 'pdfkit'

module.exports = (req, res, volunteerData)->
	console.log("buildPDF")
	res.writeHead 200, {'Content-Type': 'application/pdf'}
	doc = new PDFDocument
		size: 'A4',
		info:
		    Title: volunteerData[0].subject
		    Author: 'Wear Rivers Trust'
	doc.pipe res

	for volunteer in volunteerData
		#Create a page for each volunteer
		doc.image('static/wearRiversLogo.png',240,50,width:120)


		#doc.font('quoteImages/Helvetica.ttf')
		#doc.fillColor 'grey'
		doc.fontSize 12
		doc.font 'Helvetica-Bold'
		doc.text("Registered Office: Low Barns Nature Reserve, Witton-Le-Wear, Bishop Auckland, Co Durham, DL14 0AG. Tel: 01388 488867",120 ,140, {
			width: 370,
			align: 'center',
			height: 300,
			})


		#Draw HR
		doc.moveTo(75, 170)
	   .lineTo(545, 170)
	   .stroke()
	   doc.font 'Helvetica'
	   console.log(volunteer.address)
	   doc.text(volunteer.address,75 ,200, {
			width: 200,
			height: 80,
			})

		doc.font 'Helvetica-Bold'
		doc.text(volunteer.subject,75 ,300, {
			width: 612,
			height: 300,
			})

		doc.fontSize 12
		doc.font 'Helvetica'

		doc.text(volunteer.body,75 ,330, {
			width: 470,
			height: 300,
			})

		doc.fontSize 10
		doc.font 'Helvetica-Bold'
		doc.text("www.wear-rivers-trust.org.uk e-mail admin@wear-rivers-trust.org.uk,\n\nA Company Limited by Guarantee. Company Reg. No.4260195. Entrust Reg. No. 273153. Registered Charity No. 1094613",75 ,680, {
			width: 450,
			align: 'center',
			height: 300,
			})

		if volunteer != volunteerData[volunteerData.length-1]
 			#Keep adding new pages
 			doc.addPage()
	
	
	doc.end()