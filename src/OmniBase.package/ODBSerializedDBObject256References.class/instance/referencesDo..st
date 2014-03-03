public
referencesDo: aBlock 
	(ODBReferenceManager new)
		createMax256From: objectHolder loadBytes;
		referencesDo: aBlock