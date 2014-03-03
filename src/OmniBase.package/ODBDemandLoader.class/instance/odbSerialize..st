public
odbSerialize: serializer 
	(serializer register: objectID) ifFalse: [^serializer saveExternalReference: objectID]