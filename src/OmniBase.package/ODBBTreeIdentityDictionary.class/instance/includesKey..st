public
includesKey: aKey 
	| oid |
	^transaction isNil 
		ifTrue: [newKeys includesKey: aKey odbResolve]
		ifFalse: 
			[(oid := transaction getObjectIDOrNil: aKey) isNil 
				ifTrue: [newKeys includesKey: aKey]
				ifFalse: [super includesKey: oid]]