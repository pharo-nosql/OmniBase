public
referencesDo: aBlock 
	(ODBReferenceManager new)
		createMax65536From: objectHolder loadBytes;
		referencesDo: aBlock