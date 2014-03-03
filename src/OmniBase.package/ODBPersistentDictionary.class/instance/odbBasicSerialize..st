public
odbBasicSerialize: serializer 
	(serializer stream)
		putByte: 83;
		putPositiveInteger: self size.
	self keysAndValuesDo: 
			[:key :value | 
			key odbSerialize: serializer.
			value odbSerialize: serializer]