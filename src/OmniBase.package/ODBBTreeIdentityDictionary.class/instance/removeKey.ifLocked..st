public
removeKey: aKey ifLocked: aBlock 
	| oid |
	^transaction isNil 
		ifTrue: [newKeys removeKey: aKey odbResolve ifAbsent: []]
		ifFalse: 
			[(oid := transaction getObjectIDOrNil: aKey) isNil 
				ifTrue: [newKeys removeKey: aKey ifAbsent: []]
				ifFalse: [super removeKey: oid ifLocked: aBlock]]