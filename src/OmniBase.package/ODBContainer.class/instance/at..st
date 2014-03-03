public
at: index 
	| bytes |
	(bytes := indexFile at: index) isNil ifTrue: [^nil].
	^(ODBObjectHolder createOn: bytes) setContainer: self
		objectID: (ODBObjectID containerID: id index: index)