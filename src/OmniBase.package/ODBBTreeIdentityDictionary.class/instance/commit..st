private
commit: serializer 
	"Object IDs have been allocated. Add associations."

	newKeys keysAndValuesDo: 
			[:eachKey :eachValue | 
			self addKey: (self bytesFromKey: (transaction getObjectID: eachKey)) value: eachValue].
	super commit: serializer