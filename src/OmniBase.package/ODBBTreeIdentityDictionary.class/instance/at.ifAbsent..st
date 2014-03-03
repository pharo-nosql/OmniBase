public
at: aKey ifAbsent: aBlock 
	| oid |
	^transaction isNil 
		ifTrue: [newKeys at: aKey odbResolve ifAbsent: aBlock]
		ifFalse: 
			[(oid := transaction getObjectIDOrNil: aKey) isNil 
				ifTrue: [newKeys at: aKey ifAbsent: aBlock]
				ifFalse: [super at: oid ifAbsent: aBlock]]