public
printOn: aStream 
	aStream nextPutAll: 'Expired OmniBase proxy object of OID='.
	oid printOn: aStream