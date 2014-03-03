load/store
loadFromStream: stream 
	| n |
	n := stream getPositiveInteger.
	n > 10000 ifTrue: [self error: '[Deserialization] Too many external references'].
	n > 0 
		ifTrue: 
			[references := OrderedCollection new: n.
			n timesRepeat: [references add: (ODBObjectID new loadFromStream: stream)]]