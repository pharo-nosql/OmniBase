private
addKey: key value: anObject 
	"Private - Add association to dictionary of changed associations."

	| value |
	(value := self valueAt: key) isRemoved 
		ifTrue: [deltaSize := deltaSize + 1]
		ifFalse: 
			[transaction isNil 
				ifFalse: 
					["ce je objekt identicen ga ne shranjuj znova"
					(transaction getObjectIDOrNil: anObject) = value objectID ifTrue: [^anObject]]].
	value object: anObject.
	changed isNil ifTrue: [changed := self newChangedDictionary].
	changed at: key put: value.
	^anObject