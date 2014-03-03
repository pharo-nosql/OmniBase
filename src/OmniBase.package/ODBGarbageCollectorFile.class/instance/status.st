public
status
	"Answer garbage collector status."

	status isNil 
		ifTrue: 
			[status := stream
						position: self headerLength;
						getByte].
	^status